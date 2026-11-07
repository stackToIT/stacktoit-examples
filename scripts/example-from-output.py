#!/usr/bin/env python3
"""Refresh the figures of an example's example.json from its output/ folder.

    python3 scripts/example-from-output.py examples/<id> [--command "..."] [--mode "..."]

Everything that is a figure or a state is read from the run's own files (assessment.json, workspace.json, manifest.json,
console.txt) and written into example.json. Hand-written parts (title, summary, source description, key findings,
report pointers, publication notes) are kept as they are; the script prints the fields a person must re-read after a
new run, because a figure in a sentence does not update itself. scripts/validate.py cross-checks the result.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("example", type=Path)
    ap.add_argument("--command", help="the exact assess command, as a person typed it")
    ap.add_argument("--mode", help="how the run was made (online/offline, price source, mirror)")
    args = ap.parse_args()
    ex = args.example
    out = ex / "output"
    meta_path = ex / "example.json"
    meta = json.loads(meta_path.read_text()) if meta_path.exists() else {}

    a = json.loads((out / "assessment.json").read_text())
    w = json.loads((out / "workspace.json").read_text())
    m = json.loads((out / "manifest.json").read_text())
    console = (out / "console.txt").read_text()
    prod = a["producer"]
    kpi = w["run_summary"]["package_kpi"]
    me = w["migration_execution"]
    vm = {r["id"]: r for r in w["validation_matrix"]["rows"]}
    est = w["estate"]
    present = [u for u in a["units"] if u.get("enabled") and u.get("presence") == "KNOWN_PRESENT"]

    tool = meta.setdefault("tool", {})
    tool.update({"name": "StackToIT", "version": prod["version"], "commit": prod["commit"], "kb_version": prod["kb_version"],
                 "kb_sha256": prod["kb_sha256"], "assessment_schema": a["schema_version"], "manifest_version": m["manifest_version"],
                 "opentofu": m["validation"]["tofu_validate"].get("tool_version", "not run")})
    if prod.get("stackit_provider"):
        meta.setdefault("target", {})["provider"] = f"stackitcloud/stackit {prod['stackit_provider']}"

    run = meta.setdefault("run", {})
    run.update({"run_id": a["run"]["run_id"], "generated_at": a["generated_at"], "date": a["generated_at"][:10],
                "source_digest": a["run"]["source_digest"]})
    if args.command:
        run["command"] = args.command
    if args.mode:
        run["mode"] = args.mode
    rv = m.get("run_verification", {})
    files_listed = len(m["files"])
    if rv.get("status") == "PASSED":
        run["verify_result"] = (f"VERIFIED — {files_listed + 1} files match manifest.json (size and SHA-256); "
                                f"{len(rv.get('checks', []))} of {len(rv.get('checks', []))} checks PASS")

    mx = meta.setdefault("metrics", {})
    s = a["summary"]
    mx.update({"files_read": s["files"], "resources": s["resources"], "units": s["units"],
               "plan_time_units": s["presence"]["conditional"], "source_status": s["source_status"]})
    mc = m["source_snapshot"]["module_calls"]
    mx.update({"module_calls": mc["total"], "module_calls_external": mc["external"], "module_calls_local": mc["local"]})
    vis = re.search(r"visibility: (.+)$", console, re.M)
    if vis:
        mx.setdefault("source_visibility", vis.group(1).strip())
    mx["by_class"] = {r["key"]: r["count"] for r in est["by_class"]}
    mx["by_confidence"] = {r["key"]: r["count"] for r in est["by_confidence"]}
    dom: dict[str, int] = {}
    for u in present:
        dom[u.get("category", "other")] = dom.get(u.get("category", "other"), 0) + 1
    mx["by_domain"] = dict(sorted(dom.items(), key=lambda kv: -kv[1]))

    # draft line of the console: "Migration     38 drafted · 11 need no resource · 3 manual (of 52 units ..."
    # draft line of the console. Older builds: "Migration     38 drafted · 11 need no resource · 3 manual (of 52 units ...";
    # newer builds add "· 4 proposed, switched off" and may leave out the "need no resource" part when it is 0.
    proposed = r"(?: · (?P<off>\d+) proposed, switched off)?"
    md = re.search(r"Migration\s+(?P<gen>\d+) drafted" + proposed + r"(?: · (?P<none>\d+) need no resource)? · (?P<man>\d+) manual \(of (?P<units>\d+) units", console)
    if not md:
        md = re.search(r"STACKIT draft \([^)]*\): (?P<gen>\d+) units generated" + proposed
                       + r" · (?P<none>\d+) need no resource · (?P<man>\d+) left for the architect", console)
        ul = re.search(r"\(of (\d+) units the draft considered", console)
        if md and not ul:
            md = None
    if not md:
        raise SystemExit("console.txt: no draft line this script can read; refusing to keep the old draft figures")
    units_considered = int(md.group("units")) if "units" in md.groupdict() and md.group("units") else int(ul.group(1))
    sf = re.search(r"(\d+) Terraform-only · (\d+) hybrid", (out / "executive" / "brief.md").read_text())
    nvars = re.search(r"(\d+) variables", console)
    draft = mx.setdefault("draft", {})
    draft.update({"generated": int(md.group("gen")), "proposed_switched_off": int(md.group("off") or 0),
                  "no_resource_needed": int(md.group("none") or 0), "manual": int(md.group("man")), "units_considered": units_considered})
    if sf:
        draft.update({"terraform_only": int(sf.group(1)), "hybrid": int(sf.group(2))})
    if nvars:
        draft["variables"] = int(nvars.group(1))

    rn = kpi["runnable"]
    figs = {f.get("state"): f["n"] for f in kpi.get("figures", []) if f.get("state")}
    on_default = next((f["n"] for f in kpi.get("figures", []) if "rest on a default" in f["words"]), 0)
    manual_now = re.search(r"a person can start (\d+) of the (\d+) manual steps now", me["steps_now"])
    not_runnable = re.search(r"(\d+) steps(?: of the plan)? cannot be carried out now", me["migration_ready"])
    mx["execution"] = {
        "package_state": w["run_summary"]["package_state"], "package_state_words": me["verdict_words"],
        "plan_steps": kpi["steps"], "automated_steps": rn["automated_steps"], "automated_free_of_decisions": rn["free_of_decisions_and_prerequisites"], "automated_runs_as_written": rn["runs_as_written"], "automated_waiting_for_value": rn["need_values"],
        "automated_wait_manual_prerequisite": figs.get("MANUAL_PREREQUISITE", 0), "automated_require_design_decision": figs.get("REQUIRES_DESIGN_DECISION", 0),
        "automated_on_unconfirmed_default": on_default, "automated_approved": next((f["n"] for f in kpi.get("figures", []) if f["words"] == "are approved"), 0),
        "terraform_steps": kpi["terraform_steps"], "api_steps": kpi["api_steps"], "api_steps_waiting_opt_in": kpi.get("api_steps_waiting", 0),
        "manual_steps": int(manual_now.group(2)) if manual_now else None, "manual_can_start_now": int(manual_now.group(1)) if manual_now else None,
        "lifecycle_steps": kpi["lifecycle_steps"], "refused_steps": kpi["refused_steps"],
        "steps_not_runnable_now": int(not_runnable.group(1)) if not_runnable else None,
    }

    brief = (out / "executive" / "brief.md").read_text()
    elig = re.search(r"Automation eligibility: (\d+) of (\d+) units.*?(\d+) more become eligible once their open items are answered; (\d+) cannot be automated", brief)
    crit = re.search(r"Resolved: (\d+) of (\d+) critical settings", brief)
    rd = mx.setdefault("readiness", {})
    rd.update({"migration_ready": "YES" if me["migration_ready"].startswith("Migration ready: YES") else "NO",
               "approval": re.search(r"^(NOT READY FOR APPROVAL|READY FOR APPROVAL)", console, re.M).group(1) if re.search(r"^(NOT READY FOR APPROVAL|READY FOR APPROVAL)", console, re.M) else w["run_summary"]["architect_approval"].replace("_", " "),
               "automation_eligible_units": int(elig.group(1)) if elig else rd.get("automation_eligible_units"),
               "automation_eligible_after_open_items": int(elig.group(3)) if elig else rd.get("automation_eligible_after_open_items"),
               "cannot_be_automated_in_this_build": int(elig.group(4)) if elig else rd.get("cannot_be_automated_in_this_build"),
               "critical_settings_total": int(crit.group(2)) if crit else rd.get("critical_settings_total"),
               "critical_settings_resolved": int(crit.group(1)) if crit else rd.get("critical_settings_resolved"),
               "mapping_confidence_high": mx["by_confidence"].get("HIGH", 0)})

    att = re.search(r"(?:Attention|Decisions)\s+(\d+) decisions to make.*?(\d+) open requests \((\d+) blocks? the draft", console)
    dflt = re.search(r"the default of (\d+) (?:decisions|records) nobody has answered", console) or re.search(r"(\d+) defaults? to confirm", console)
    nxt = re.search(r"^Next(?: action)?:?\s+(.+?) · details", console, re.M)
    dc = mx.setdefault("decisions", {})
    dc.update({"records_open": w["decision_register"]["counts"]["records"],
               "decisions_to_make": int(att.group(1)) if att else dc.get("decisions_to_make"),
               "defaults_to_confirm": int(dflt.group(1)) if dflt else dc.get("defaults_to_confirm"),
               "open_input_requests": int(att.group(2)) if att else dc.get("open_input_requests"),
               "input_requests_blocking_draft": int(att.group(3)) if att else dc.get("input_requests_blocking_draft"),
               "first_required_action": nxt.group(1) if nxt else dc.get("first_required_action")})

    apps_line = re.search(r"^(\d+) applications?: (\d+) ready · (\d+) blocked · (\d+) redesign · (\d+) not ready", brief, re.M) \
        or re.search(r"^(\d+) groups? PROPOSED by StackToIT .*?: (\d+) Migration-ready · (\d+) blocked · (\d+) redesign · (\d+) not Migration-ready", brief, re.M)
    apm = mx.setdefault("applications", {})
    if apps_line:
        apm.update({"total": int(apps_line.group(1)), "ready": int(apps_line.group(2)), "blocked": int(apps_line.group(3)),
                    "redesign": int(apps_line.group(4)), "not_ready": int(apps_line.group(5))})
        states = {n: st for n, st in re.findall(r"^- \*\*([\w-]+)\*\* — ([A-Z -]+?) · PROPOSED", brief, re.M)}
        known = {r["name"] for r in apm.setdefault("list", [])}
        apm["list"] += [{"name": n, "state": "", "why": ""} for n in states if n not in known]  # "why" is written by hand
        for row in apm["list"]:
            if row["name"] in states:
                row["state"] = states[row["name"]].strip().replace("MIGRATION-", "").replace(" ", "_")

    cost_line = re.search(r"^Cost\s+(.+)$", console, re.M) or re.search(r"^- Cost: (.+)$", brief, re.M)
    cm = mx.setdefault("cost", {})
    tot = next((t for t in w["cost_model"]["totals"] if t.get("scope") == "estate" and t.get("side") == "TARGET"), None)
    src = next((t for t in w["cost_model"]["totals"] if t.get("scope") == "estate" and t.get("side") == "SOURCE"), None)
    if cost_line:
        head = cost_line.group(1)
        cm["comparison"] = "NOT AVAILABLE" if "NOT AVAILABLE" in head else "AVAILABLE"
        cm.setdefault("why", head.split(" — ", 1)[1].split(" · ")[0] if " — " in head else head)  # hand-written value is kept
    if tot:
        cm["stackit_partial_eur"] = tot.get("min")
        cm["stackit_lines_priced"] = f"{tot['priced_lines']} of {tot['priced_lines'] + tot['unpriced_lines']}"
    if src:
        cm["source_lines_priced"] = f"{src['priced_lines']} of {src['priced_lines'] + src['unpriced_lines']}"

    v = mx.setdefault("validation", {})
    sv = re.search(r"^source validation: (\w+)(?: \((\w+)\))?: (.+)$", console, re.M)
    v["source_completeness"] = {"state": vm["SOURCE_COMPLETENESS"]["state"], "detail": vm["SOURCE_COMPLETENESS"]["detail"] + (f": {m['source_snapshot'].get('reason', '')}" if False else "")}
    reason = w["header"]["source_snapshot"].get("reason", "")
    v["source_completeness"]["detail"] = f"source status {s['source_status']}" + (f": {reason}" if reason else "")
    prov = next((p for p in w["header"]["source_snapshot"]["providers"] if p["name"] == "aws"), w["header"]["source_snapshot"]["providers"][0])
    v["source_provider"] = {"state": prov["status"], "detail": f"{prov['name']} constraints {', '.join(prov['constraints'][-1:])}, tested against {prov['tested_against'] or 'n/a'}; {prov['note']}"}
    native = s["source_validation"]["native"]  # the structured answer; the console line, when there is one, carries the reason in words
    if sv:
        v["source_opentofu"] = {"state": sv.group(1), "reason": (f"{sv.group(2)} — " if sv.group(2) else "") + sv.group(3)}
    else:
        v["source_opentofu"] = {"state": native["status"], "reason": "OpenTofu validation of the source was not requested (assess ran with --no-validate); the built-in source checks ran: " + ", ".join(c["id"] for c in s["source_validation"]["checks"]) + " OK"}
    v["draft_generation"] = {"state": vm["DRAFT_GENERATION"]["state"], "detail": vm["DRAFT_GENERATION"]["detail"]}
    v["draft_checks"] = {"state": vm["STACKTOIT_DRAFT_CHECKS"]["state"], "detail": vm["STACKTOIT_DRAFT_CHECKS"]["detail"]}
    v["global_invariants"] = {"state": vm["GLOBAL_INVARIANTS"]["state"], "detail": vm["GLOBAL_INVARIANTS"]["detail"]}
    v["draft_opentofu"] = {"state": m["validation"]["tofu_validate"]["state"], "detail": vm["TOFU_STATIC_VALIDATION"]["detail"] + " — " + m["validation"]["tofu_validate"]["scope"]}
    v["manifest"] = {"state": "VERIFIED" if rv.get("status") == "PASSED" else rv.get("status", "UNKNOWN"),
                     "detail": f"{files_listed + 1} files match manifest.json; " + ", ".join(c["id"] for c in rv.get("checks", [])) + " PASS"}
    v["not_established"] = [{"id": k, "state": vm[k]["state"], "detail": vm[k]["detail"]} for k in ("STACKIT_PLAN", "ARCHITECT_APPROVAL", "SEMANTIC_EQUIVALENCE", "SAFE_TO_APPLY") if k in vm]
    capped = {"UNPINNED": "capped at MEDIUM: the source provider is unpinned",
              "UNVERIFIED": "capped at MEDIUM: the source provider version is not verified (no lock file, and its constraint excludes the release the knowledge base was checked against)"}
    mx["confidence_note"] = capped.get(prov["status"], "") if mx["by_confidence"].get("HIGH", 0) == 0 else ""

    pub = meta.setdefault("publication", {})
    on_disk = sorted(str(p.relative_to(out)) for p in out.rglob("*") if p.is_file())
    listed = {e["path"] for e in m["files"]}
    pub.update({"published_files": len(on_disk), "manifest_files": len(listed), "outside_manifest": [p for p in on_disk if p not in listed]})

    meta_path.write_text(json.dumps(meta, indent=2, ensure_ascii=False) + "\n")
    print(f"example.json refreshed from {out}")
    print("Re-read by hand (figures inside sentences do not update themselves): summary, source.note, key_findings[*].text, "
          "metrics.applications.list[*].why, metrics.cost.price_source, metrics.decisions.defaults_to_confirm_note, README.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
