# Google Cloud Dynamic Python Web App → STACKIT

One StackToIT run on the Terraform estate of Google Cloud's Dynamic Python Web App Jump Start Solution, published unchanged.

**Example page:** https://stacktoit.com/examples/examples/gcp-python-webapp/
**Full assessment:** https://stacktoit.com/examples/examples/gcp-python-webapp/report/

## Source

| | |
|---|---|
| Project | terraform-dynamic-python-webapp, by Google Cloud (GoogleCloudPlatform) |
| Repository | https://github.com/GoogleCloudPlatform/terraform-dynamic-python-webapp |
| Commit | `7c9e8fb8f0d4d57f0564c70917ae06a07c176d17` ([tree](https://github.com/GoogleCloudPlatform/terraform-dynamic-python-webapp/tree/7c9e8fb8f0d4d57f0564c70917ae06a07c176d17)) |
| Terraform root | `infra` |
| Registry modules | 1, downloaded by the run: terraform-google-modules/project-factory/google//modules/project_services 18.0.0 |
| Licence | Apache-2.0 (upstream `LICENSE`) |
| Edited | Nothing. The estate was assessed as published; it ships no `.terraform.lock.hcl`. |
| Variable file | one line, `project_id = "example-project"` (an invented name): `project_id` is the only required variable without a default |

The source code itself is not republished here; the links above point to the exact upstream revision.

## Tool

| | |
|---|---|
| StackToIT | `0.6.0-13076-ga19ea28c64` (commit `a19ea28c64`) |
| Knowledge base | `0.394.0` (sha256 `480e323d0c501840bc553e30e3073fca5f51c5c45a9e7d91ed4a4ff36d6a50d0`) |
| Assessment schema · manifest | `0.24.0` · `0.4.0` |
| STACKIT provider | `0.121.0` |
| OpenTofu | `1.13.1` |

## Run

| | |
|---|---|
| Date | 2026-11-07 (`generated_at` 2026-11-07T04:24:17Z) |
| Run id | `6f8f72b2-1c34-4cfc-8483-344c41245364` |
| Source digest | `sha256:19bfed642d5789ccada81b91d5c36e33175dcafd66dc46b1644ffa105d020000` |
| Command | `stacktoit assess . ../../run-python-webapp --var-file ../../example.tfvars`, run from `infra/` of a clone at the pinned commit — default options (online; the run downloaded the one registry module; STACKIT list prices from the local price cache, last filled 2026-11-02). |
| Verification | `stacktoit verify ../../run-python-webapp` → **VERIFIED**: 146 files match `manifest.json` (size and SHA-256); EVIDENCE, SCHEMA, RUN_ID, BASIS, INPUTS_DIGEST, INVALIDATION_KEYS all PASS |

## Validation, as the run recorded it

| Check | State | Note |
|---|---|---|
| Source completeness | PARTIAL | 5 units have a `count`/`for_each` decided only when OpenTofu plans |
| Source provider | UNVERIFIED | `google >= 6, < 8`, no lock file; the constraint excludes 8.4.0, the release the knowledge base was checked against; confidence capped at MEDIUM, no automation eligibility |
| Source validation (OpenTofu) | NOT_RUN | `LOCK_FILE`: the source has no `.terraform.lock.hcl`, so StackToIT does not pick a provider version for it. Neither a pass nor a failure. |
| Draft checks (StackToIT) | PASSED | 20 checks, no violation |
| Global invariants | PASSED | 12 of 12 (3 of them had nothing to check) |
| Draft validation (OpenTofu) | PASSED | `tofu init -backend=false` and `tofu validate` on the draft; static, against the provider schema |
| STACKIT plan | NOT_RUN | no plan against a live project |
| Architect approval | NOT_PROVIDED | the package is a proposal |
| Semantic equivalence | NOT_ASSESSED | |
| Safe to apply | NOT_ASSERTED | |

## Result in one paragraph

37 resources in 18 files, 11 migration units present (5 more decided at plan time). Classification: 6 RECONFIGURE, 2 REPLATFORM (Cloud SQL to PostgreSQL Flex, Pub/Sub to RabbitMQ), 2 CONTAINERIZE (the Cloud Run service and job to STACKIT Kubernetes Engine), 1 MANUAL_REVIEW (the Firebase project), 0 DIRECT, 0 REDESIGN, 0 BLOCKED; confidence 10 MEDIUM, 1 LOW. The draft generates 11 of the 16 units it considered as 10 STACKIT resource blocks, 4 are proposed and switched off, 1 is left to the architect; 13 variables. Package state **PARTIALLY_EXECUTABLE**: 10 of 12 automated steps are free of decisions and wait only for values, 0 can run as written, 0 approved; 2 refused. **Migration ready: NO**, 0 of 11 units automation-eligible. 6 decisions to make (the first: allow STACKIT APIs that are not generally available, owner Platform Architect), 27 open input requests (7 block parts of the draft). Cost comparison NOT AVAILABLE (no Google Cloud price in the cache; 2 of 8 STACKIT lines priced, 164.67 EUR partial). Applications: 2 proposed groups (server, migrate), neither confirmed nor ready.

## What is in `output/`

| Folder / file | Content |
|---|---|
| `index.html`, `pages/` | the HTML Workspace (12 pages) |
| `assessment.json`, `workspace.json`, `target-plan.json`, `execution-plan.json`, `decisions.json` | machine-readable results |
| `architecture/` | current, target, delta, network-security, data-flows (SVG + Mermaid); dependencies, identity (Mermaid) |
| `executive/` | `brief.md`, `decisions.md` |
| `terraform/` | the STACKIT draft: `terraform.tf`, `variables.tf`, `identity.tf`, `security.tf`, `data.tf`, `storage.tf`, `messaging.tf`, `kubernetes.tf`, `proposals.tf`, `kubernetes/`, `rabbitmq/`, `proposals/`, `handover/` |
| `execution/` | `README.md`, `terraform/`, `api/` (STACKIT API scripts), `manual/`, `verify/` |
| `migration/` | waves, work board, work packages, data movement (CSV, Markdown, JSON), roadmap, landing-zone requirements |
| `financial/` | cost model, price snapshot, mapping and coverage |
| `assurance/`, `engineering/` | evidence and equivalence ledgers, resilience, identity transition, architect report, review sheet |
| `review/` | `inputs.yaml`, `decisions.yaml`, `applications.yaml`, `progress.yaml`, `target-values.tfvars` — unanswered |
| `manifest.json`, `console.txt` | file manifest with hashes; the console output of the run |

151 files; 145 are listed in `manifest.json`, the manifest itself and the five `review/` files are outside it by the tool's own rule. Nothing was removed, edited or redacted for publication.
