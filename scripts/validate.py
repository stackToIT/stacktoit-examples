#!/usr/bin/env python3
"""Validate the examples and, optionally, a built site.

    python3 scripts/validate.py            # metadata schema, manifest integrity, metadata-vs-output cross-checks
    python3 scripts/validate.py --site _site   # the same, plus a broken-link check over the built site

Standard library only. Exit code 1 on any failure; every failure is printed.
"""
from __future__ import annotations

import argparse
import hashlib
import html.parser
import json
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parent.parent
EXAMPLES = ROOT / "examples"
SCHEMA = ROOT / "schema" / "example.schema.json"

failures: list[str] = []


def fail(msg: str) -> None:
    failures.append(msg)
    print(f"FAIL  {msg}")


def ok(msg: str) -> None:
    print(f"ok    {msg}")


# ---------------------------------------------------------------- schema (minimal JSON Schema subset)

def check_schema(value, schema, path: str) -> None:
    t = schema.get("type")
    if t:
        py = {"object": dict, "array": list, "string": str, "integer": int, "number": (int, float), "boolean": bool}[t]
        if t == "integer" and isinstance(value, bool) or not isinstance(value, py):
            fail(f"{path}: expected {t}, got {type(value).__name__}")
            return
    if "enum" in schema and value not in schema["enum"]:
        fail(f"{path}: {value!r} not in {schema['enum']}")
    if "pattern" in schema and isinstance(value, str) and not re.search(schema["pattern"], value):
        fail(f"{path}: {value!r} does not match /{schema['pattern']}/")
    if isinstance(value, dict):
        for req in schema.get("required", []):
            if req not in value:
                fail(f"{path}: missing required key {req!r}")
        props = schema.get("properties", {})
        for k, v in value.items():
            if k in props:
                check_schema(v, props[k], f"{path}.{k}")
            elif "additionalProperties" in schema and isinstance(schema["additionalProperties"], dict):
                check_schema(v, schema["additionalProperties"], f"{path}.{k}")
    if isinstance(value, list):
        if "minItems" in schema and len(value) < schema["minItems"]:
            fail(f"{path}: fewer than {schema['minItems']} items")
        if "items" in schema:
            for i, item in enumerate(value):
                check_schema(item, schema["items"], f"{path}[{i}]")


# ---------------------------------------------------------------- per example

def sha256(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def check_manifest(ex_dir: Path, meta: dict) -> None:
    out = ex_dir / "output"
    manifest = json.loads((out / "manifest.json").read_text())
    listed = {e["path"]: e for e in manifest["files"]}
    on_disk = {str(p.relative_to(out)) for p in out.rglob("*") if p.is_file()}
    bad = 0
    for rel, e in listed.items():
        p = out / rel
        if not p.exists():
            fail(f"{meta['id']}: manifest lists {rel} but it is missing"); bad += 1; continue
        if p.stat().st_size != e["bytes"] or sha256(p) != e["sha256"]:
            fail(f"{meta['id']}: {rel} differs from manifest.json (size or SHA-256)"); bad += 1
    if not bad:
        ok(f"{meta['id']}: {len(listed)} files match manifest.json (size and SHA-256)")
    allowed_outside = set(meta["publication"]["outside_manifest"])
    unlisted = on_disk - set(listed) - allowed_outside
    if unlisted:
        fail(f"{meta['id']}: files on disk neither in manifest nor declared outside it: {sorted(unlisted)}")
    missing_declared = allowed_outside - on_disk
    if missing_declared:
        fail(f"{meta['id']}: declared outside-manifest files absent: {sorted(missing_declared)}")
    pub = meta["publication"]
    if pub["published_files"] != len(on_disk):
        fail(f"{meta['id']}: publication.published_files={pub['published_files']} but {len(on_disk)} files are on disk")
    if pub["manifest_files"] != len(listed):
        fail(f"{meta['id']}: publication.manifest_files={pub['manifest_files']} but the manifest lists {len(listed)}")
    return manifest


def check_cross(ex_dir: Path, meta: dict, manifest: dict) -> None:
    """Figures in example.json must be the output's own figures."""
    out = ex_dir / "output"
    a = json.loads((out / "assessment.json").read_text())
    w = json.loads((out / "workspace.json").read_text())
    prod = a["producer"]
    checks = [
        ("tool.version", meta["tool"]["version"], prod["version"]),
        ("tool.commit", meta["tool"]["commit"], prod["commit"]),
        ("tool.kb_version", meta["tool"]["kb_version"], prod["kb_version"]),
        ("tool.kb_sha256", meta["tool"]["kb_sha256"], prod["kb_sha256"]),
        ("tool.assessment_schema", meta["tool"]["assessment_schema"], a["schema_version"]),
        ("tool.manifest_version", meta["tool"]["manifest_version"], manifest["manifest_version"]),
        ("tool.opentofu", meta["tool"]["opentofu"], manifest["validation"]["tofu_validate"]["tool_version"]),
        ("run.run_id", meta["run"]["run_id"], a["run"]["run_id"]),
        ("run.generated_at", meta["run"]["generated_at"], a["generated_at"]),
        ("run.source_digest", meta["run"]["source_digest"], a["run"]["source_digest"]),
        ("metrics.files_read", meta["metrics"]["files_read"], a["summary"]["files"]),
        ("metrics.resources", meta["metrics"]["resources"], a["summary"]["resources"]),
        ("metrics.units", meta["metrics"]["units"], a["summary"]["units"]),
        ("metrics.source_status", meta["metrics"]["source_status"], a["summary"]["source_status"]),
        ("metrics.module_calls", meta["metrics"]["module_calls"], manifest["source_snapshot"]["module_calls"]["total"]),
        ("metrics.execution.package_state", meta["metrics"]["execution"]["package_state"], w["run_summary"]["package_state"]),
        ("metrics.execution.plan_steps", meta["metrics"]["execution"]["plan_steps"], w["run_summary"]["package_kpi"]["steps"]),
        ("metrics.execution.automated_steps", meta["metrics"]["execution"]["automated_steps"], w["run_summary"]["package_kpi"]["runnable"]["automated_steps"]),
        ("metrics.execution.automated_can_run_now", meta["metrics"]["execution"]["automated_can_run_now"], w["run_summary"]["package_kpi"]["runnable"]["can_run_now"]),
        ("metrics.execution.refused_steps", meta["metrics"]["execution"]["refused_steps"], w["run_summary"]["package_kpi"]["refused_steps"]),
        ("metrics.validation.draft_opentofu.state", meta["metrics"]["validation"]["draft_opentofu"]["state"], manifest["validation"]["tofu_validate"]["state"]),
    ]
    by_class = {r["key"]: r["count"] for r in w["estate"]["by_class"]}
    by_conf = {r["key"]: r["count"] for r in w["estate"]["by_confidence"]}
    for k, v in meta["metrics"]["by_class"].items():
        checks.append((f"metrics.by_class.{k}", v, by_class.get(k, 0)))
    for k, v in meta["metrics"]["by_confidence"].items():
        checks.append((f"metrics.by_confidence.{k}", v, by_conf.get(k, 0)))
    vm = {r["id"]: r["state"] for r in w["validation_matrix"]["rows"]}
    checks.append(("validation.source_completeness.state", meta["metrics"]["validation"]["source_completeness"]["state"], vm["SOURCE_COMPLETENESS"]))
    checks.append(("validation.draft_generation.state", meta["metrics"]["validation"]["draft_generation"]["state"], vm["DRAFT_GENERATION"]))
    checks.append(("validation.draft_checks.state", meta["metrics"]["validation"]["draft_checks"]["state"], vm["STACKTOIT_DRAFT_CHECKS"]))
    checks.append(("validation.global_invariants.state", meta["metrics"]["validation"]["global_invariants"]["state"], vm["GLOBAL_INVARIANTS"]))
    for row in meta["metrics"]["validation"]["not_established"]:
        checks.append((f"validation.not_established.{row['id']}", row["state"], vm.get(row["id"])))
    src_val = (out / "console.txt").read_text().split("\n", 3)[2]
    stated = meta["metrics"]["validation"]["source_opentofu"]["state"]
    if not src_val.startswith(f"source validation: {stated}"):
        fail(f"{meta['id']}: validation.source_opentofu.state={stated} but console.txt says: {src_val[:80]}")
    provider = next(p for p in w["header"]["source_snapshot"]["providers"] if p["name"] == "aws")
    checks.append(("validation.source_provider.state", meta["metrics"]["validation"]["source_provider"]["state"], provider["status"]))
    bad = 0
    for name, stated, actual in checks:
        if stated != actual:
            fail(f"{meta['id']}: {name} is {stated!r} in example.json but {actual!r} in the output"); bad += 1
    if not bad:
        ok(f"{meta['id']}: {len(checks)} figures in example.json match the output")
    for key in ("entry", "executive_brief", "decisions", "execution_plan", "manual_actions", "roadmap", "data_movement", "manifest", "console"):
        rel = meta["report"].get(key)
        if rel and not (out / rel).exists():
            fail(f"{meta['id']}: report.{key} points to {rel}, which does not exist")
    for key in ("architecture_dir", "terraform_dir"):
        if not (out / meta["report"][key]).is_dir():
            fail(f"{meta['id']}: report.{key} is not a directory")


def check_examples() -> list[dict]:
    schema = json.loads(SCHEMA.read_text())
    metas = []
    dirs = sorted(p for p in EXAMPLES.iterdir() if p.is_dir())
    if not dirs:
        fail("no examples found")
    for ex_dir in dirs:
        mp = ex_dir / "example.json"
        if not mp.exists():
            fail(f"{ex_dir.name}: example.json missing"); continue
        meta = json.loads(mp.read_text())
        before = len(failures)
        check_schema(meta, schema, ex_dir.name)
        if meta.get("id") != ex_dir.name:
            fail(f"{ex_dir.name}: id {meta.get('id')!r} does not match the folder name")
        if not (ex_dir / "README.md").exists():
            fail(f"{ex_dir.name}: README.md missing")
        if len(failures) == before:
            ok(f"{ex_dir.name}: example.json conforms to the schema")
            manifest = check_manifest(ex_dir, meta)
            if manifest:
                check_cross(ex_dir, meta, manifest)
        metas.append(meta)
    return metas


# ---------------------------------------------------------------- built site link check

class LinkParser(html.parser.HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.refs: list[str] = []
        self.ids: set[str] = set()

    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        for key in ("href", "src", "data", "poster"):
            if d.get(key):
                self.refs.append(d[key])
        if d.get("srcset"):
            for part in d["srcset"].split(","):
                self.refs.append(part.strip().split(" ")[0])
        if d.get("id"):
            self.ids.add(d["id"])
        if tag == "a" and d.get("name"):
            self.ids.add(d["name"])


PLACEHOLDER = re.compile(r"\$\{?[a-z][a-z0-9_]*\}?")
SECRET_SHAPES = [
    (re.compile(r"AKIA[0-9A-Z]{16}"), "AWS access key id"),
    (re.compile(r"\bASIA[0-9A-Z]{16}\b"), "AWS session key id"),
    (re.compile(r"\bgh[pousr]_[A-Za-z0-9]{20,}\b"), "GitHub token"),
    (re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"), "private key"),
    (re.compile(r"\beyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{10,}\."), "JWT"),
    (re.compile(r"(?i)\b(secret|token|password|passwd|api[_-]?key)\s*[:=]\s*['\"][^'\"\s]{8,}['\"]"), "credential assignment"),
    (re.compile(r"(?<![\w/])/(?:Users|home)/[A-Za-z0-9._-]+/"), "absolute user path"),
]
EMAIL = re.compile(r"[A-Za-z0-9._%+-]+@(?!stacktoit\.com\b)[A-Za-z0-9.-]+\.[a-z]{2,}")


def check_public_content(site: Path) -> None:
    """Generic leak classes over everything the site publishes, authored pages and the copied report alike:
    secret shapes, absolute user paths, e-mail addresses other than the project's, unresolved template placeholders
    and HTML comments in the authored pages (the report keeps its own markup)."""
    hits = 0
    for p in sorted(site.rglob("*")):
        if not p.is_file() or p.suffix in {".woff2", ".png", ".webp", ".svg"}:
            continue
        rel = p.relative_to(site).as_posix()
        text = p.read_text(errors="replace")
        for rx, what in SECRET_SHAPES:
            if rx.search(text):
                fail(f"public content: {what} in {rel}"); hits += 1
        for m_ in EMAIL.finditer(text):
            addr = m_.group(0)
            if "@module." in addr or addr.endswith((".tf", ".this", ".aws", ".catalog", ".checkout", ".orders")):
                continue  # plan step ids of the form name@module.x.y are not addresses
            fail(f"public content: e-mail address {addr} in {rel}"); hits += 1; break
        authored = p.suffix == ".html" and "/report/" not in f"/{rel}"
        if authored:
            if "/files/" in f"/{rel}":  # a viewer page embeds a file of the run; only the chrome around it is authored
                text = re.sub(r'<div class="wrap viewer-body">.*?</main>', "", text, flags=re.S)
            if PLACEHOLDER.search(text):
                fail(f"public content: unresolved template placeholder {PLACEHOLDER.search(text).group(0)} in {rel}"); hits += 1
            if "<!--" in text:
                fail(f"public content: HTML comment in authored page {rel}"); hits += 1
    if not hits:
        ok("public content: no secret shapes, user paths, foreign e-mail addresses, placeholders or authored HTML comments")


def check_site(site: Path, clean_urls: bool = False) -> None:
    if not site.is_dir():
        fail(f"site folder {site} does not exist"); return
    check_public_content(site)
    if not (site / ".nojekyll").exists():
        fail("site is missing .nojekyll (GitHub Pages would hide folders starting with _ and run Jekyll)")
    pages = sorted(site.rglob("*.html"))
    # only the site's own pages are checked for anchors; the report pages are checked for file targets
    checked = broken = 0
    ids_cache: dict[Path, set[str]] = {}

    def ids_of(p: Path) -> set[str]:
        if p not in ids_cache:
            lp = LinkParser(); lp.feed(p.read_text(errors="replace")); ids_cache[p] = lp.ids
        return ids_cache[p]

    for page in pages:
        lp = LinkParser()
        lp.feed(page.read_text(errors="replace"))
        ids_cache[page] = lp.ids
        for ref in lp.refs:
            u = urlsplit(ref)
            if u.scheme in ("http", "https", "mailto", "data", "javascript", "tel") or ref.startswith("//"):
                continue
            if ref.startswith("/") and page.name == "404.html" and page.parent == site:
                continue  # the 404 page is served at any depth and must use the project base path
            if ref.startswith("/"):
                fail(f"{page.relative_to(site)}: root-relative link {ref!r} breaks under the project base path"); broken += 1; continue
            target_path = unquote(u.path)
            target = page if not target_path else (page.parent / target_path).resolve()
            if target.is_dir():
                target = target / "index.html"
            elif clean_urls and not target.exists() and target.with_name(target.name + ".html").exists():
                target = target.with_name(target.name + ".html")
            checked += 1
            if not target.exists():
                fail(f"{page.relative_to(site)}: broken link {ref!r}"); broken += 1; continue
            if u.fragment and target.suffix == ".html" and site in target.parents and "report" not in target.relative_to(site).parts:
                if u.fragment not in ids_of(target):
                    fail(f"{page.relative_to(site)}: anchor #{u.fragment} not found in {target.relative_to(site)}"); broken += 1
    if not broken:
        ok(f"site: {checked} internal references in {len(pages)} pages resolve")
    # every published report file must be present in the site copy, byte for byte
    for ex_dir in sorted(p for p in EXAMPLES.iterdir() if p.is_dir()):
        src = ex_dir / "output"; dst = site / ("" if clean_urls else "examples") / ex_dir.name / "report"
        mism = [str(p.relative_to(src)) for p in src.rglob("*") if p.is_file() and (not (dst / p.relative_to(src)).exists() or sha256(dst / p.relative_to(src)) != sha256(p))]
        if mism:
            fail(f"site: {len(mism)} report files differ from examples/{ex_dir.name}/output (e.g. {mism[0]})")
        else:
            ok(f"site: examples/{ex_dir.name}/report is a byte-for-byte copy of the output")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--site", type=Path, help="built site folder to link-check")
    ap.add_argument("--clean-urls", action="store_true", help="the site is built for Cloudflare, where foo serves foo.html")
    args = ap.parse_args()
    check_examples()
    if args.site:
        check_site(args.site.resolve(), args.clean_urls)
    print()
    if failures:
        print(f"{len(failures)} failure(s)")
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
