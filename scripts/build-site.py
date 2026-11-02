#!/usr/bin/env python3
"""Build the static site into _site/ from examples/*/example.json and site/.

    python3 scripts/build-site.py [--out _site]

Standard library only, deterministic (no timestamps, sorted iteration). Every link is relative so the
site works under a GitHub Pages project path (https://<org>.github.io/<repo>/).

Pages written per example <id>:
    examples/<id>/index.html            the example page (generated from the template)
    examples/<id>/report/**             the StackToIT output, copied byte for byte
    examples/<id>/files/<path>.html     read-only viewers for the Terraform draft and the Markdown documents
"""
from __future__ import annotations

import argparse
import html
import json
import re
import shutil
from pathlib import Path
from string import Template

ROOT = Path(__file__).resolve().parent.parent
EXAMPLES = ROOT / "examples"
SITE = ROOT / "site"
TEMPLATES = SITE / "templates"

SITE_CONFIG = json.loads((SITE / "site.json").read_text())  # repository and Pages addresses; nothing else about the deployment is in the templates
BASE_PATH = "/" + SITE_CONFIG["pages_url"].rstrip("/").rsplit("/", 1)[-1] + "/"  # only the 404 page needs it; every other link is relative

CLASS_ORDER = ["DIRECT", "RECONFIGURE", "REPLATFORM", "CONTAINERIZE", "REDESIGN", "MANUAL_REVIEW", "BLOCKED"]
CLASS_WORDS = {
    "DIRECT": "same service, same settings",
    "RECONFIGURE": "same kind of service, settings change",
    "REPLATFORM": "a different managed service",
    "CONTAINERIZE": "packaged into a container first",
    "REDESIGN": "no counterpart; the architecture changes",
    "MANUAL_REVIEW": "a person decides",
    "BLOCKED": "cannot move as it stands",
}
VIEWER_SUFFIXES = {".tf", ".md", ".txt", ".yaml", ".yml", ".csv", ".mmd", ".sh", ".json"}

E = html.escape


def tpl(name: str) -> Template:
    return Template((TEMPLATES / name).read_text())


def render(name: str, **kw) -> str:
    return tpl(name).safe_substitute(**kw)


ATTRIBUTIONS: list[str] = []  # filled from every example's source.attribution before any page is written


def page(root: str, title: str, description: str, body: str, nav_examples: str = "") -> str:
    return render("base.html", root=root, title=title, description=description, body=body, nav_examples=nav_examples,
                  attributions=" ".join(E(a) for a in ATTRIBUTIONS))


def state_cls(state: str) -> str:
    return state.lower().replace("_", "-").replace(" ", "-")


def fmt(n) -> str:
    return f"{n:,}" if isinstance(n, int) else str(n)


def sizeof(n: int) -> str:
    for unit in ("B", "KB", "MB"):
        if n < 1024 or unit == "MB":
            return f"{n:.0f} {unit}" if unit == "B" else f"{n:.1f} {unit}"
        n /= 1024
    return f"{n:.1f} MB"


# ---------------------------------------------------------------- tiny Markdown → HTML (for the viewers)

INLINE = [
    (re.compile(r"`([^`]+)`"), lambda m: f"<code>{E(m.group(1))}</code>"),
    (re.compile(r"\*\*([^*]+)\*\*"), lambda m: f"<strong>{inline(m.group(1))}</strong>"),
    (re.compile(r"(?<!\*)\*([^*\n]+)\*(?!\*)"), lambda m: f"<em>{inline(m.group(1))}</em>"),
    (re.compile(r"\[([^\]]+)\]\((https?://[^)\s]+)\)"), lambda m: f'<a href="{E(m.group(2))}" rel="noopener">{inline(m.group(1))}</a>'),
]


def inline(text: str) -> str:
    # protect code spans first
    parts = re.split(r"(`[^`]+`)", text)
    out = []
    for part in parts:
        if part.startswith("`") and part.endswith("`") and len(part) > 1:
            out.append(f"<code>{E(part[1:-1])}</code>")
        else:
            s = E(part)
            s = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", s)
            s = re.sub(r"(?<![\w*])\*([^*\n]+)\*(?![\w*])", r"<em>\1</em>", s)
            s = re.sub(r"\[([^\]]+)\]\((https?://[^)\s]+)\)", r'<a href="\2" rel="noopener">\1</a>', s)
            out.append(s)
    return "".join(out)


def md_to_html(src: str) -> str:
    lines = src.split("\n")
    out: list[str] = []
    i = 0
    para: list[str] = []

    def flush_para():
        if para:
            out.append(f"<p>{inline(' '.join(para))}</p>")
            para.clear()

    while i < len(lines):
        line = lines[i]
        if line.startswith("```"):
            flush_para()
            j = i + 1
            code = []
            while j < len(lines) and not lines[j].startswith("```"):
                code.append(lines[j]); j += 1
            out.append(f"<pre><code>{E(chr(10).join(code))}</code></pre>")
            i = j + 1; continue
        m = re.match(r"^(#{1,6})\s+(.*)$", line)
        if m:
            flush_para()
            lvl = min(len(m.group(1)) + 1, 6)  # the page already has an h1
            out.append(f"<h{lvl}>{inline(m.group(2))}</h{lvl}>")
            i += 1; continue
        if line.startswith(">"):
            flush_para()
            quote = []
            while i < len(lines) and lines[i].startswith(">"):
                quote.append(lines[i].lstrip("> ")); i += 1
            out.append(f"<blockquote><p>{inline(' '.join(quote))}</p></blockquote>")
            continue
        if line.startswith("|") and i + 1 < len(lines) and re.match(r"^\|[\s:|-]+\|?\s*$", lines[i + 1]):
            flush_para()
            head = [c.strip() for c in line.strip().strip("|").split("|")]
            i += 2
            rows = []
            while i < len(lines) and lines[i].startswith("|"):
                rows.append([c.strip() for c in lines[i].strip().strip("|").split("|")]); i += 1
            out.append("<table><thead><tr>" + "".join(f"<th>{inline(h)}</th>" for h in head) + "</tr></thead><tbody>"
                       + "".join("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in r) + "</tr>" for r in rows) + "</tbody></table>")
            continue
        m = re.match(r"^(\s*)([-*]|\d+\.)\s+(.*)$", line)
        if m:
            flush_para()
            ordered = m.group(2)[0].isdigit()
            tag = "ol" if ordered else "ul"
            items = []
            base_indent = len(m.group(1))
            while i < len(lines):
                mm = re.match(r"^(\s*)([-*]|\d+\.)\s+(.*)$", lines[i])
                if mm and len(mm.group(1)) == base_indent:
                    items.append([mm.group(3)]); i += 1
                elif lines[i].strip() and (lines[i].startswith(" " * (base_indent + 2)) or lines[i].startswith("\t")) and items:
                    items[-1].append(lines[i].strip()); i += 1
                else:
                    break
            out.append(f"<{tag}>" + "".join(f"<li>{inline(' '.join(it))}</li>" for it in items) + f"</{tag}>")
            continue
        if line.strip() == "---":
            flush_para(); out.append("<hr>"); i += 1; continue
        if not line.strip():
            flush_para(); i += 1; continue
        para.append(line.strip()); i += 1
    flush_para()
    return "\n".join(out)


# ---------------------------------------------------------------- fragments

def class_strip(by_class: dict, units: int) -> str:
    cells = []
    for k in CLASS_ORDER:
        n = by_class.get(k, 0)
        if n:
            cells.append(f'<span class="cls cls-{k.lower()}" style="flex:{n} 0 auto" title="{k}: {n} of {units} units"><b>{n}</b><span class="word">{k}</span></span>')
    legend = "".join(
        f'<li class="{"is-zero" if not by_class.get(k, 0) else ""}"><span class="swatch cls-{k.lower()}"></span><b>{by_class.get(k, 0)}</b> {k} <small>{E(CLASS_WORDS[k])}</small></li>'
        for k in CLASS_ORDER)
    return f'<div class="strip" role="img" aria-label="Classification of {units} units">{"".join(cells)}</div><ul class="legend">{legend}</ul>'


def field(label: str, value: str, cls: str = "") -> str:
    return f'<div class="field {cls}"><span class="lab">{E(label)}</span><span class="val">{value}</span></div>'


def validation_rows(v: dict) -> str:
    rows = [
        ("Source completeness", v["source_completeness"]["state"], v["source_completeness"]["detail"]),
        ("Source provider", v["source_provider"]["state"], v["source_provider"]["detail"]),
        ("Source validation (OpenTofu)", v["source_opentofu"]["state"], v["source_opentofu"]["reason"]),
        ("Draft generation", v["draft_generation"]["state"], v["draft_generation"]["detail"]),
        ("Draft checks (StackToIT)", v["draft_checks"]["state"], v["draft_checks"]["detail"]),
        ("Global invariants", v["global_invariants"]["state"], v["global_invariants"]["detail"]),
        ("Draft validation (OpenTofu)", v["draft_opentofu"]["state"], v["draft_opentofu"]["detail"]),
        ("Run folder (stacktoit verify)", v["manifest"]["state"], v["manifest"]["detail"]),
    ]
    rows += [(r["id"].replace("_", " ").title(), r["state"], r["detail"]) for r in v["not_established"]]
    return "".join(
        f'<tr><th scope="row">{E(n)}</th><td><span class="state st-{state_cls(s)}">{E(s)}</span></td><td>{E(d)}</td></tr>'
        for n, s, d in rows)


def file_tree(out: Path, sub: str, viewer_prefix: str, report_prefix: str) -> tuple[str, list[Path]]:
    base = out / sub
    files = sorted(p for p in base.rglob("*") if p.is_file())
    rows = []
    for p in files:
        rel = p.relative_to(out).as_posix()
        if p.suffix in VIEWER_SUFFIXES:
            href = f"{viewer_prefix}{rel}.html"
        else:
            href = f"{report_prefix}{rel}"
        depth = len(p.relative_to(base).parts) - 1
        rows.append(f'<li style="--d:{depth}"><a href="{E(href)}">{E(p.relative_to(base).as_posix())}</a><span class="sz">{sizeof(p.stat().st_size)}</span></li>')
    return f'<ul class="files">{"".join(rows)}</ul>', files


def write_viewer(dst: Path, title: str, rel: str, body_html: str, root: str, kind: str, raw_href: str, example_title: str, example_href: str) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    body = render("viewer.html", title=E(title), rel=E(rel), body=body_html, kind=kind, raw_href=E(raw_href),
                  example_title=E(example_title), example_href=E(example_href))
    dst.write_text(page(root, f"{E(title)} · {E(example_title)} · StackToIT Examples",
                        E(f"{rel} from the StackToIT migration package for {example_title}"), body))


def write_listings(report_copy: Path, meta: dict) -> None:
    """The report links to folders (`../terraform/`), which a file system shows and a web server does not.
    Each folder of the site copy without an index.html gets a plain listing page. These pages exist only in
    the built site, never in examples/<id>/output/, and say so."""
    for d in sorted(p for p in [report_copy, *report_copy.rglob("*")] if p.is_dir()):
        if (d / "index.html").exists():
            continue
        rel = d.relative_to(report_copy).as_posix()
        depth = len(Path(rel).parts)
        up = "../" * depth
        entries = sorted(d.iterdir(), key=lambda p: (p.is_file(), p.name))
        rows = "".join(
            f'<li><a href="{E(p.name)}{"/" if p.is_dir() else ""}">{E(p.name)}{"/" if p.is_dir() else ""}</a>'
            f'<span class="sz">{"folder" if p.is_dir() else sizeof(p.stat().st_size)}</span></li>' for p in entries)
        body = (f'<div class="wrap viewer-body"><nav class="crumbs" aria-label="Breadcrumb" style="color:var(--ink-2)">'
                f'<a href="{up}index.html">Report</a><span aria-hidden="true">/</span><span class="mono">{E(rel)}/</span></nav>'
                f'<h1 style="font-size:1.6rem;text-transform:none;margin:0 0 8px">{E(rel)}/</h1>'
                f'<p class="note">Folder of the StackToIT package for {E(meta["title"])}. This listing page is generated for the web site and is not a file of the run; '
                f'the run\'s own files are listed in <a href="{up}manifest.json">manifest.json</a>.</p>'
                f'<ul class="files">{rows}</ul><p class="note" style="margin-top:16px"><a href="{up}../index.html">Back to the example</a></p></div>')
        root = "../" * (depth + 3)  # report/<rel> is under examples/<id>/report/
        (d / "index.html").write_text(page(root, f"{E(rel)}/ · {E(meta['title'])} · StackToIT Examples",
                                           E(f"Folder listing of {rel}/ in the StackToIT package for {meta['title']}"), body))


# ---------------------------------------------------------------- pages

def build_example(meta: dict, ex_dir: Path, out_dir: Path) -> dict:
    ex_id = meta["id"]
    root = "../../"
    dest = out_dir / "examples" / ex_id
    report = ex_dir / "output"
    shutil.copytree(report, dest / "report", dirs_exist_ok=True)
    shutil.copy(ex_dir / "example.json", dest / "example.json")
    write_listings(dest / "report", meta)

    m = meta["metrics"]; v = m["validation"]; ex = m["execution"]; rd = m["readiness"]; dr = m["draft"]; dc = m["decisions"]; ap = m["applications"]; cost = m["cost"]

    # viewers for the draft and the documents
    tf_tree, tf_files = file_tree(report, meta["report"]["terraform_dir"], "files/", "report/")
    doc_keys = ["executive_brief", "decisions", "execution_plan", "manual_actions", "roadmap", "data_movement", "console", "manifest"]
    doc_paths = [meta["report"][k] for k in doc_keys if meta["report"].get(k)]
    viewer_targets = list(tf_files) + [report / d for d in doc_paths] + sorted((report / "architecture").glob("*.mmd"))
    for p in viewer_targets:
        rel = p.relative_to(report).as_posix()
        text = p.read_text(errors="replace")
        if p.suffix == ".md":
            body = f'<article class="prose">{md_to_html(text)}</article>'; kind = "document"
        else:
            body = f'<pre class="code" tabindex="0"><code>{E(text)}</code></pre>'; kind = "file"
        depth = len(Path(rel).parts)  # files/<rel>.html is under examples/<id>/files/..., the root is depth+1 up
        vroot = "../" * (depth + 2)
        write_viewer(dest / "files" / f"{rel}.html", Path(rel).name, rel, body, vroot, kind,
                     raw_href="../" * depth + "report/" + rel, example_title=meta["title"], example_href="../" * depth + "index.html")

    docs_list = "".join(
        f'<li><a href="files/{E(meta["report"][k])}.html">{E(meta["report"][k])}</a><span class="sz">{E(label)}</span></li>'
        for k, label in [("executive_brief", "executive brief"), ("decisions", "decision register"), ("execution_plan", "execution package"),
                         ("manual_actions", "manual actions"), ("roadmap", "roadmap"), ("data_movement", "data movement"),
                         ("console", "console output"), ("manifest", "manifest")] if meta["report"].get(k))

    pages_dir = report / "pages"
    report_pages = "".join(
        f'<li><a href="report/pages/{E(p.name)}">{E(p.stem.replace("-", " "))}</a></li>' for p in sorted(pages_dir.glob("*.html"))) if pages_dir.is_dir() else ""

    findings = "".join(f'<li><h4>{E(f["title"])}</h4><p>{E(f["text"])}</p></li>' for f in meta["key_findings"])
    arch = report / meta["report"]["architecture_dir"]
    shown = {"current", "target", "delta"}
    others = []
    for stem in sorted({p.stem for p in arch.glob("*.mmd")} | {p.stem for p in arch.glob("*.svg")}):
        if stem in shown:
            continue
        label = stem.replace("-", " ")
        if (arch / f"{stem}.svg").exists():
            others.append(f'<a href="report/{meta["report"]["architecture_dir"]}/{stem}.svg">{E(label)}</a>')
        else:
            others.append(f'<a href="files/{meta["report"]["architecture_dir"]}/{stem}.mmd.html">{E(label)}</a> (Mermaid only)')
    other_diagrams = ", ".join(others) if others else "no further views"
    applications_block = ""
    if ap.get("list"):
        applications_block = render("applications.html", apps_total=fmt(ap["total"]), apps_ready=fmt(ap["ready"]), apps_blocked=fmt(ap.get("blocked", 0)),
                                    apps_redesign=fmt(ap.get("redesign", 0)), apps_not_ready=fmt(ap.get("not_ready", 0)), apps_rows="".join(
            f'<tr><th scope="row">{E(a["name"])}</th><td><span class="state st-{state_cls(a["state"])}">{E(a["state"].replace("_", " "))}</span></td><td>{E(a["why"])}</td></tr>'
            for a in ap["list"]))
    cost_block = ""
    if cost:
        cost_block = render("cost.html", cost_comparison=E(cost["comparison"]), cost_cls=state_cls(cost["comparison"]), cost_why=E(cost["why"]),
                            cost_stackit=E(cost.get("stackit_partial_eur", "")), cost_stackit_lines=E(cost.get("stackit_lines_priced", "")),
                            cost_source_lines=E(cost.get("source_lines_priced", "")), price_source=E(cost.get("price_source", "")), target_cloud=E(meta["target"]["cloud"]))
    domains = ", ".join(f"{E(k)} {n}" for k, n in sorted(m.get("by_domain", {}).items(), key=lambda kv: -kv[1]))

    body = render(
        "example.html",
        root=root, id=E(ex_id), title=E(meta["title"]), summary=E(meta["summary"]),
        source_cloud=E(meta["source"]["cloud"]), target_cloud=E(meta["target"]["cloud"]), target_provider=E(meta["target"]["provider"]),
        project_name=E(meta["source"]["project_name"]), maintainer=E(meta["source"]["maintainer"]),
        repo_url=E(meta["source"]["repository_url"]), commit=E(meta["source"]["commit"]), commit_short=E(meta["source"]["commit"][:12]),
        commit_url=E(meta["source"]["commit_url"]), tf_root=E(meta["source"]["terraform_root"]), tf_root_url=E(meta["source"]["terraform_root_url"]),
        source_license=E(meta["source"]["license"]), registry_modules=E(meta["source"].get("registry_modules", "")), source_note=E(meta["source"].get("note", "")),
        source_description=E(meta["source"]["description"]), confidence_note=E(m.get("confidence_note", "")), other_diagrams=other_diagrams,
        applications_block=applications_block, cost_block=cost_block,
        draft_validation=E(v["draft_opentofu"]["state"]), draft_validation_cls=state_cls(v["draft_opentofu"]["state"]),
        iac=E(meta["source"]["iac"]),
        example_repo_url=E(f"{SITE_CONFIG['repository_url']}/tree/{SITE_CONFIG['repository_branch']}/examples/{ex_id}"),
        repo_name=E(SITE_CONFIG["repository_url"].rstrip("/").rsplit("/", 1)[-1]),
        tool_version=E(meta["tool"]["version"]), tool_commit=E(meta["tool"]["commit"]), kb=E(meta["tool"]["kb_version"]), kb_sha=E(meta["tool"]["kb_sha256"]),
        schema=E(meta["tool"]["assessment_schema"]), opentofu=E(meta["tool"]["opentofu"]),
        run_id=E(meta["run"]["run_id"]), date=E(meta["run"]["date"]), generated_at=E(meta["run"]["generated_at"]), mode=E(meta["run"]["mode"]),
        command=E(meta["run"]["command"]), command_note=E(meta["run"].get("command_note", "")), verify_command=E(meta["run"]["verify_command"]),
        verify_result=E(meta["run"]["verify_result"]), source_digest=E(meta["run"]["source_digest"]),
        files_read=fmt(m["files_read"]), resources=fmt(m["resources"]), units=fmt(m["units"]), plan_time_units=fmt(m.get("plan_time_units", 0)),
        module_calls=fmt(m["module_calls"]), module_ext=fmt(m.get("module_calls_external", 0)), module_local=fmt(m.get("module_calls_local", 0)),
        source_visibility=E(m["source_visibility"]), domains=domains,
        class_strip=class_strip(m["by_class"], m["units"]),
        conf_medium=fmt(m["by_confidence"]["MEDIUM"]), conf_low=fmt(m["by_confidence"]["LOW"]), conf_high=fmt(m["by_confidence"]["HIGH"]),
        drafted=fmt(dr["generated"]), no_resource=fmt(dr["no_resource_needed"]), manual_units=fmt(dr["manual"]), variables=fmt(dr["variables"]),
        units_considered=fmt(dr.get("units_considered", 0)), tf_only=fmt(dr.get("terraform_only", 0)), hybrid=fmt(dr.get("hybrid", 0)),
        package_state=E(ex["package_state"].replace("_", " ")), package_words=E(ex["package_state_words"]),
        plan_steps=fmt(ex["plan_steps"]), automated=fmt(ex["automated_steps"]), can_run=fmt(ex["automated_can_run_now"]),
        wait_manual=fmt(ex.get("automated_wait_manual_prerequisite", 0)), need_decision=fmt(ex.get("automated_require_design_decision", 0)),
        on_default=fmt(ex.get("automated_on_unconfirmed_default", 0)), approved=fmt(ex.get("automated_approved", 0)),
        tf_steps=fmt(ex.get("terraform_steps", 0)), api_steps=fmt(ex.get("api_steps", 0)), api_wait=fmt(ex.get("api_steps_waiting_opt_in", 0)),
        manual_steps=fmt(ex.get("manual_steps", 0)), manual_now=fmt(ex.get("manual_can_start_now", 0)), lifecycle=fmt(ex.get("lifecycle_steps", 0)),
        refused=fmt(ex["refused_steps"]), not_runnable=fmt(ex.get("steps_not_runnable_now", 0)),
        migration_ready=E(rd["migration_ready"]), approval=E(rd["approval"]), eligible=fmt(rd["automation_eligible_units"]),
        eligible_later=fmt(rd.get("automation_eligible_after_open_items", 0)), cannot_automate=fmt(rd.get("cannot_be_automated_in_this_build", 0)),
        crit_total=fmt(rd.get("critical_settings_total", 0)), crit_resolved=fmt(rd.get("critical_settings_resolved", 0)),
        live=E(rd.get("live_verification", "")),
        decisions_to_make=fmt(dc["decisions_to_make"]), defaults=fmt(dc.get("defaults_to_confirm", 0)), defaults_note=E(dc.get("defaults_to_confirm_note", "")),
        open_requests=fmt(dc["open_input_requests"]), blocking=fmt(dc.get("input_requests_blocking_draft", 0)), first_action=E(dc["first_required_action"]),
        validation_rows=validation_rows(v), findings=findings, tf_tree=tf_tree, docs_list=docs_list, report_pages=report_pages,
        published_files=fmt(meta["publication"]["published_files"]), manifest_files=fmt(meta["publication"]["manifest_files"]),
        outside_manifest=", ".join(E(x) for x in meta["publication"]["outside_manifest"]), outside_note=E(meta["publication"].get("outside_manifest_note", "")),
        pub_statement=E(meta["publication"]["statement"]),
        excluded=E(", ".join(meta["publication"]["excluded"]) or "none"), modified=E(", ".join(meta["publication"]["modified"]) or "none"),
    )
    (dest / "index.html").write_text(page(root, f"{E(meta['title'])} · StackToIT Examples",
        E(f"StackToIT migration assessment of {meta['title']} ({meta['source']['cloud']} → {meta['target']['cloud']}), run {meta['run']['date']}."),
        body, "is-current"))
    return {
        "href": f"examples/{ex_id}/", "meta": meta,
    }


def build_index(cards: list[dict], out_dir: Path) -> None:
    rows = []
    for c in cards:
        meta = c["meta"]; m = meta["metrics"]; ex = m["execution"]; rd = m["readiness"]; dr = m["draft"]
        rows.append(render(
            "card.html",
            href=E(c["href"]), title=E(meta["title"]), summary=E(meta["summary"]),
            source_cloud=E(meta["source"]["cloud"]), target_cloud=E(meta["target"]["cloud"]),
            repo_url=E(meta["source"]["repository_url"]), repo_name=E(meta["source"]["project_name"]), commit_short=E(meta["source"]["commit"][:12]),
            commit_url=E(meta["source"]["commit_url"]), tf_root=E(meta["source"]["terraform_root"]),
            date=E(meta["run"]["date"]), tool_version=E(meta["tool"]["version"]), kb=E(meta["tool"]["kb_version"]),
            migration_ready=E(rd["migration_ready"]), package_state=E(ex["package_state"].replace("_", " ")),
            resources=fmt(m["resources"]), units=fmt(m["units"]), drafted=fmt(dr["generated"]), no_resource=fmt(dr["no_resource_needed"]),
            units_considered=fmt(dr.get("units_considered", 0)), plan_time_units=fmt(m.get("plan_time_units", 0)), manual_units=fmt(dr["manual"]),
            source_validation_cls=state_cls(m["validation"]["source_opentofu"]["state"]), draft_validation_cls=state_cls(m["validation"]["draft_opentofu"]["state"]),
            can_run=fmt(ex["automated_can_run_now"]), automated=fmt(ex["automated_steps"]), eligible=fmt(rd["automation_eligible_units"]),
            decisions=fmt(m["decisions"]["decisions_to_make"]), refused=fmt(ex["refused_steps"]),
            source_validation=E(m["validation"]["source_opentofu"]["state"].replace("_", " ")), draft_validation=E(m["validation"]["draft_opentofu"]["state"]),
            class_strip=class_strip(m["by_class"], m["units"]),
            first_finding=E(meta["key_findings"][0]["title"]) if meta["key_findings"] else "",
        ))
    hero_actions = "".join(
        f'<a class="btn btn-primary" href="{E(c["href"])}report/index.html">View the {E(c["meta"]["title"])} assessment</a>' for c in cards[:1]
    ) + '<a class="btn btn-ghost" href="#register">Open the register</a><a class="btn btn-ghost" href="#reading">What the states mean</a>'
    body = render("index.html", root="", cards="".join(rows), count=str(len(cards)), plural="" if len(cards) == 1 else "s", hero_actions=hero_actions)
    (out_dir / "index.html").write_text(page("", "StackToIT Examples",
        "Real migration assessments produced by StackToIT on public infrastructure-as-code projects: source estate, classifications, STACKIT Terraform draft, execution plan, open decisions.",
        body, "is-current"))
    # GitHub Pages serves 404.html for any missing URL, at any depth, so this one page uses the project base path.
    not_found = render("404.html", root=BASE_PATH)
    (out_dir / "404.html").write_text(page(BASE_PATH, "Page not found · StackToIT Examples", "This page does not exist.", not_found))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", type=Path, default=ROOT / "_site")
    args = ap.parse_args()
    out_dir = args.out.resolve()
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True)
    shutil.copytree(SITE / "assets", out_dir / "assets")
    (out_dir / ".nojekyll").write_text("")
    shutil.copy(ROOT / "schema" / "example.schema.json", out_dir / "assets" / "example.schema.json")
    metas = [json.loads((ex_dir / "example.json").read_text()) for ex_dir in sorted(p for p in EXAMPLES.iterdir() if p.is_dir())]
    ATTRIBUTIONS.extend(dict.fromkeys(m["source"]["attribution"] for m in metas))
    cards = []
    for ex_dir, meta in zip(sorted(p for p in EXAMPLES.iterdir() if p.is_dir()), metas):
        cards.append(build_example(meta, ex_dir, out_dir))
        print(f"built examples/{meta['id']}/")
    build_index(cards, out_dir)
    n = sum(1 for _ in out_dir.rglob("*") if _.is_file())
    print(f"site written to {out_dir} ({n} files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
