#!/usr/bin/env python3
"""Validate the examples.

    python3 scripts/validate.py            # metadata schema, manifest integrity, metadata-vs-output cross-checks

Standard library only. Exit code 1 on any failure; every failure is printed.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
EXAMPLES = ROOT / "examples"
SCHEMA = ROOT / "schema" / "example.schema.json"

failures: list[str] = []

# the Terraform provider that carries the source estate of each cloud
SOURCE_PROVIDER = {"AWS": "aws", "Azure": "azurerm", "Google Cloud": "google"}
UPSTREAM_FIELDS = ("repository_url", "commit", "commit_url", "terraform_root_url")


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
        ("tool.opentofu", meta["tool"]["opentofu"], manifest["validation"]["tofu_validate"].get("tool_version", "not run")),
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
        ("metrics.execution.automated_free_of_decisions", meta["metrics"]["execution"]["automated_free_of_decisions"], w["run_summary"]["package_kpi"]["runnable"]["free_of_decisions_and_prerequisites"]),
        ("metrics.execution.automated_runs_as_written", meta["metrics"]["execution"]["automated_runs_as_written"], w["run_summary"]["package_kpi"]["runnable"]["runs_as_written"]),
        ("metrics.execution.automated_waiting_for_value", meta["metrics"]["execution"]["automated_waiting_for_value"], w["run_summary"]["package_kpi"]["runnable"]["need_values"]),
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
    stated = meta["metrics"]["validation"]["source_opentofu"]["state"]
    checks.append(("validation.source_opentofu.state", stated, a["summary"]["source_validation"]["native"]["status"]))
    src_val = re.search(r"^source validation: (\w+)", (out / "console.txt").read_text(), re.M)
    if src_val:  # a run that validated or tried to validate the source also says so in its console output
        checks.append(("validation.source_opentofu.state (console.txt)", stated, src_val.group(1)))
    provider_name = SOURCE_PROVIDER[meta["source"]["cloud"]]
    provider = next(p for p in w["header"]["source_snapshot"]["providers"] if p["name"] == provider_name)
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


def check_source(ex_dir: Path, meta: dict) -> None:
    """An upstream estate is pinned to a public commit; an authored estate is published in the example itself."""
    src = meta.get("source", {})
    origin = src.get("origin", "upstream")
    if origin == "upstream":
        for k in UPSTREAM_FIELDS:
            if k not in src:
                fail(f"{ex_dir.name}: source.{k} is required for an upstream estate")
        if "commit" in src and not re.fullmatch(r"[0-9a-f]{40}", src["commit"]):
            fail(f"{ex_dir.name}: source.commit is not a full 40-character commit")
    else:
        folder = ex_dir / src.get("source_path", "")
        if not src.get("source_path") or not folder.is_dir() or not list(folder.rglob("*.tf")):
            fail(f"{ex_dir.name}: source.source_path must name a folder of the example that holds the assessed .tf files")


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
        check_source(ex_dir, meta)
        if len(failures) == before:
            ok(f"{ex_dir.name}: example.json conforms to the schema")
            manifest = check_manifest(ex_dir, meta)
            if manifest:
                check_cross(ex_dir, meta, manifest)
        metas.append(meta)
    return metas


def main() -> int:
    check_examples()
    print()
    if failures:
        print(f"{len(failures)} failure(s)")
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
