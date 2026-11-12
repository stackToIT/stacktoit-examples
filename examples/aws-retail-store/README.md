# AWS Retail Store Sample App → STACKIT

One StackToIT run on the ECS Terraform estate of the AWS Retail Store Sample App, published unchanged.

**Example page:** https://stacktoit.com/examples/examples/aws-retail-store/
**Full assessment:** https://stacktoit.com/examples/examples/aws-retail-store/report/

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
| StackToIT | `0.6.0-14852-ge0bf936cda` (commit `e0bf936cda`) |
| Knowledge base | `0.428.0` (sha256 `269b6fb01d33e7b35c499690a7dc997b27fb67834e6ea10318bcc645927bf696`) |
| Assessment schema · manifest | `0.26.0` · `0.4.0` |
| STACKIT provider | `0.121.0` |
| OpenTofu | `1.13.1` |

## Run

| | |
|---|---|
| Date | 2026-11-12 (`generated_at` 2026-11-12T05:04:15Z) |
| Run id | `20b9b72e-9147-46e6-a2d7-0782ad201937` |
| Source digest | `sha256:9289ba9abd2e1e953630f7ab62d12070ed65ca36d687d125b7e6cf755d020000` |
| Command | `stacktoit assess terraform/ecs/default ./aws-retail-store --provider-mirror DIR` — default options (online; prices from the local price cache retrieved 2026-10-26). `DIR` is a local OpenTofu provider mirror prepared first with `tofu providers mirror -platform=darwin_arm64 DIR` in the Terraform root (hashicorp/aws 5.100.0, hashicorp/random 3.7.x), as the first run's console suggested. |
| Verification | `stacktoit verify ./aws-retail-store` → **VERIFIED**: 175 files match `manifest.json` (size and SHA-256); 7 of 7 checks PASS (EVIDENCE, SCHEMA, RUN_ID, BASIS, INPUTS_DIGEST, INVALIDATION_KEYS, EXECUTION_PLAN) |

## Validation, as the run recorded it

| Check | State | Note |
|---|---|---|
| Source completeness | PARTIAL | 8 units have a `count`/`for_each` decided only when OpenTofu plans |
| Source provider | UNPINNED | `aws ~> 5.0`, no lock file; tested against 5.100.0; confidence capped at MEDIUM, no automation eligibility |
| Source validation (OpenTofu) | NOT_RUN | `LOCK_FILE`: the source has no `.terraform.lock.hcl`, so provider identity and integrity cannot be verified and StackToIT does not pick a version for it; a prepared provider mirror does not change this. Neither a pass nor a failure. |
| Draft checks (StackToIT) | PASSED | 100 checks, no violation |
| Global invariants | PENDING | 11 of 12 PASS; the open one is NO_SECURITY_WIDENING (see below) |
| Draft validation (OpenTofu) | PASSED | `tofu init -backend=false` and `tofu validate` on the draft; static, against the provider schema |
| STACKIT plan | NOT_RUN | no plan against a live project |
| Architect approval | NOT_PROVIDED | the package is a proposal |
| Semantic equivalence | NOT_ASSESSED | |
| Safe to apply | NOT_ASSERTED | |

## Result in one paragraph

282 resources in 105 files, 44 migration units present (8 more decided at plan time). Classification: 34 RECONFIGURE, 9 REPLATFORM, 1 REDESIGN, 0 DIRECT, 0 MANUAL_REVIEW, 0 BLOCKED; confidence 35 MEDIUM, 9 LOW. The draft generates 34 units (29 Terraform only, 5 Terraform plus STACKIT API), 16 need no resource (15 of them carry steps), 2 are left to the architect; 59 variables. Package state **PARTIALLY_EXECUTABLE**: 29 of 49 automated steps are free of decisions and manual prerequisites, 19 require a design decision, 1 can run as written, 0 approved; 283 manual steps; 2 refused. **Migration ready: NO**, 0 of 44 units automation-eligible. 19 decisions to make, 87 open input requests (11 block the draft, 37 block the apply). Cost comparison NOT AVAILABLE (the source names no AWS region; 5 of 14 STACKIT lines priced). Applications: 0 of 5 ready (catalog blocked by the OpenSearch engine version; carts and checkout redesign because DynamoDB has no counterpart; orders and ui not ready).

## What changed since the previous version of this example (build 8183bbe919, knowledge base 0.420.0)

The source is the same and so is every unit's classification and confidence (282 resources, 44 units, 49 automated steps, 87 open requests). What moved:

- **Two steps wait for a person's choice of strategy.** The SKE cluster that replaces the ECS services and the MongoDB Flex instance that replaces the DynamoDB tables are alternatives StackToIT proposes, not counterparts. Their OpenTofu steps now wait until a person chooses the way the capability moves (container runtime, NoSQL table), and choosing the way the draft writes frees them. Steps free of decisions go from 31 to 29 and steps that require a design decision from 17 to 19. This is a correctness gain: the draft no longer writes a replacement nobody has chosen.
- **One strategy decision per capability.** The proposed alternatives are decided per capability (container runtime, NoSQL table, event rule): three new decision records; 19 decisions to make, against 16.
- **The EventBridge rule of the ECS events is a reviewed critical setting.** One more decision record for it.
- **Fewer separate manual steps for the task roles.** The CloudWatch agent attachment a plan-time input switches off is now read as part of each task role's own review, so the five separate manual steps for it are gone (283 manual steps, against 288).
- **New pages for the steering group.** `executive/steering-decisions.md` and `executive/accepted-differences.md` list the decisions and the accepted differences in the words of a steering paper.

The security-widening check is unchanged: it stays PENDING because what a STACKIT project role allows has no public source.

## What is in `output/`

| Folder / file | Content |
|---|---|
| `index.html`, `pages/` | the HTML Workspace (12 pages, plus 10 decision-group pages in `pages/decisions/`) |
| `assessment.json`, `workspace.json`, `target-plan.json`, `execution-plan.json`, `decisions.json` | machine-readable results; the `*-template.yaml` and `target-values-template.tfvars` files are the answer templates |
| `architecture/` | current, target, delta, network-security, data-flows (SVG + Mermaid); dependencies, identity (Mermaid) |
| `executive/` | `brief.md`, `decisions.md`, `steering-decisions.md`, `accepted-differences.md` |
| `terraform/` | the STACKIT draft: `terraform.tf`, `variables.tf`, `network.tf`, `security.tf`, `identity.tf`, `data.tf`, `kubernetes.tf`, `loadbalancing.tf`, `messaging.tf`, `observability.tf`, `kubernetes/`, `applications/`, `handover/` |
| `execution/` | `README.md`, `terraform/apply.md`, `api/` (STACKIT API scripts), `manual/actions.md`, `verify/checks.md` |
| `migration/` | waves, work board, work packages, data movement (CSV, Markdown, JSON), roadmap, landing-zone requirements |
| `financial/` | cost model, price snapshot, mapping and coverage |
| `assurance/`, `engineering/` | evidence and equivalence ledgers, resilience, identity transition, architect report, review sheet |
| `review/` | `inputs.yaml`, `decisions.yaml`, `applications.yaml`, `progress.yaml`, `target-values.tfvars` — unanswered |
| `manifest.json`, `console.txt` | file manifest with hashes; the console output of the run |

180 files; 174 are listed in `manifest.json`, the manifest itself and the five `review/` files are outside it by the tool's own rule. Nothing was removed, edited or redacted for publication.
