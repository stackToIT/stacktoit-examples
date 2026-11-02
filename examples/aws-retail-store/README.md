# AWS Retail Store Sample App → STACKIT

One StackToIT run on the ECS Terraform estate of the AWS Retail Store Sample App, published unchanged.

**Example page:** https://stacktoit.github.io/stacktoit-examples/examples/aws-retail-store/
**Full assessment:** https://stacktoit.github.io/stacktoit-examples/examples/aws-retail-store/report/index.html

## Source

| | |
|---|---|
| Project | Retail Store Sample App, by AWS Containers (aws-containers) |
| Repository | https://github.com/aws-containers/retail-store-sample-app |
| Commit | `d7a380b843e0759e58754f74188ea18252a51415` ([tree](https://github.com/aws-containers/retail-store-sample-app/tree/d7a380b843e0759e58754f74188ea18252a51415)) |
| Terraform root | `terraform/ecs/default` (plus the local `terraform/lib` modules it calls) |
| Registry modules | 13, as resolved by OpenTofu on 2026-10-26 (terraform-aws-modules vpc 5.21.0, alb 8.7.0, security-group 4.17.2, rds-aurora 7.7.1, dynamodb-table 3.3.0, opensearch 1.5.0; cloudposse elasticache-redis 0.53.0, security-group 1.0.1, route53-cluster-hostname 0.12.2, label 0.25.0) |
| Licence | MIT-0 (upstream `LICENSE`); the modules are Apache-2.0 |
| Edited | Nothing. The estate was assessed as published; it ships no `.terraform.lock.hcl`. |

The source code itself is not republished here; the links above point to the exact upstream revision.

## Tool

| | |
|---|---|
| StackToIT | `0.6.0-11562-g1966ddf116` (commit `1966ddf116`) |
| Knowledge base | `0.384.0` (sha256 `fc24dfbd7370bd23bbae090adf2960acf5d9b4ac749be7362ac50053ceddc6d9`) |
| Assessment schema · manifest | `0.24.0` · `0.4.0` |
| STACKIT provider | `0.121.0` |
| OpenTofu | `1.13.1` |

## Run

| | |
|---|---|
| Date | 2026-11-02 (`generated_at` 2026-11-02T12:08:24Z) |
| Run id | `f6267c3f-2848-4aa5-89df-5fee8b15b3b9` |
| Source digest | `sha256:812c5ae3f6cc8530163abbf5b6fbe305ed3b363c4886ec6b87623db857ea0c70` |
| Command | `stacktoit assess terraform/ecs/default ./aws-retail-store --provider-mirror DIR` — default options (online; prices from the local price cache retrieved 2026-10-26). `DIR` is a local OpenTofu provider mirror prepared first with `tofu providers mirror -platform=darwin_arm64 DIR` in the Terraform root (hashicorp/aws 5.100.0, hashicorp/random 3.7.x), as the first run's console suggested. |
| Verification | `stacktoit verify ./aws-retail-store` → **VERIFIED**: 143 files match `manifest.json` (size and SHA-256); EVIDENCE, SCHEMA, RUN_ID, BASIS, INPUTS_DIGEST, INVALIDATION_KEYS, EXECUTION_PLAN all PASS |

## Validation, as the run recorded it

| Check | State | Note |
|---|---|---|
| Source completeness | PARTIAL | 8 units have a `count`/`for_each` decided only when OpenTofu plans |
| Source provider | UNPINNED | `aws ~> 5.0`, no lock file; tested against 5.100.0; confidence capped at MEDIUM, no automation eligibility |
| Source validation (OpenTofu) | NOT_RUN | `LOCK_FILE`: the source has no `.terraform.lock.hcl`, so provider identity and integrity cannot be verified and StackToIT does not pick a version for it; a prepared provider mirror does not change this. Neither a pass nor a failure. |
| Draft checks (StackToIT) | PASSED | 100 checks, no violation |
| Global invariants | PASSED | 12 of 12 |
| Draft validation (OpenTofu) | PASSED | `tofu init -backend=false` and `tofu validate` on the draft; static, against the provider schema |
| STACKIT plan | NOT_RUN | no plan against a live project |
| Architect approval | NOT_PROVIDED | the package is a proposal |
| Semantic equivalence | NOT_ASSESSED | |
| Safe to apply | NOT_ASSERTED | |

## Result in one paragraph

282 resources in 105 files, 44 migration units present (8 more decided at plan time). Classification: 34 RECONFIGURE, 9 REPLATFORM, 1 REDESIGN, 0 DIRECT, 0 MANUAL_REVIEW, 0 BLOCKED; confidence 35 MEDIUM, 9 LOW. The draft generates 38 units, 11 need no resource, 3 are left to the architect; 60 variables. Package state **PARTIALLY_EXECUTABLE**: 48 of 57 automated steps can run now, 9 of them on a default nobody confirmed, 0 approved; 254 manual steps; 3 refused. **Migration ready: NO**, 0 of 44 units automation-eligible. 16 decisions to make, 47 open input requests (14 block parts of the draft). Cost comparison NOT AVAILABLE (the source names no AWS region; 5 of 14 STACKIT lines priced). Applications: 0 of 5 ready (catalog blocked by the OpenSearch engine version; carts and checkout redesign because DynamoDB has no counterpart; orders and ui not ready).

## What is in `output/`

| Folder / file | Content |
|---|---|
| `index.html`, `pages/` | the HTML Workspace (12 pages) |
| `assessment.json`, `workspace.json`, `target-plan.json`, `execution-plan.json`, `decisions.json`, `inputs.json`, `preflight.json` | machine-readable results |
| `architecture/` | current, target, delta, network-security, data-flows (SVG + Mermaid); dependencies, identity (Mermaid) |
| `executive/` | `brief.md`, `decisions.md` |
| `terraform/` | the STACKIT draft: `terraform.tf`, `variables.tf`, `network.tf`, `security.tf`, `identity.tf`, `data.tf`, `kubernetes.tf`, `loadbalancing.tf`, `messaging.tf`, `observability.tf`, `kubernetes/`, `applications/`, `handover/` |
| `execution/` | `README.md`, `terraform/apply.md`, `api/` (STACKIT API scripts), `manual/actions.md`, `verify/checks.md` |
| `migration/` | waves, work board, work packages, data movement (CSV, Markdown, JSON), roadmap, landing-zone requirements |
| `financial/` | cost model, price snapshot, mapping and coverage |
| `assurance/`, `engineering/` | evidence and equivalence ledgers, resilience, identity transition, architect report, review sheet |
| `review/` | `inputs.yaml`, `decisions.yaml`, `applications.yaml`, `progress.yaml` — unanswered |
| `manifest.json`, `console.txt` | file manifest with hashes; the console output of the run |

147 files; 142 are listed in `manifest.json`, the manifest itself and the four `review/` files are outside it by the tool's own rule. Nothing was removed, edited or redacted for publication.
