# StackToIT Examples

Real migration assessments produced by StackToIT on public AWS Terraform projects.

StackToIT reads a Terraform estate and writes a migration package for STACKIT: the assessment of every resource, a STACKIT Terraform draft, an ordered execution plan and the decisions that are still open. This repository publishes such runs exactly as the tool wrote them, with the metadata needed to check them.

**Site:** https://stacktoit.github.io/stacktoit-examples/

## Examples

| Example | Source | Assessed | Result |
|---|---|---|---|
| [AWS Retail Store Sample App](examples/aws-retail-store/) | [aws-containers/retail-store-sample-app](https://github.com/aws-containers/retail-store-sample-app) @ `d7a380b8`, `terraform/ecs/default` | 2026-11-02 | 282 resources, 44 units · 34 RECONFIGURE / 9 REPLATFORM / 1 REDESIGN · 38 units drafted · migration ready: **NO** · [full assessment](https://stacktoit.github.io/stacktoit-examples/examples/aws-retail-store/report/index.html) |

## What a run produces

Each example's `output/` folder is one StackToIT run, unchanged:

- `index.html` and `pages/` — the Migration Intelligence Workspace (the HTML report)
- `assessment.json`, `workspace.json`, `target-plan.json`, `execution-plan.json` — the machine-readable results
- `architecture/` — current, target and delta diagrams (SVG and Mermaid), network, data-flow, identity views
- `executive/` — the executive brief and the decision register
- `terraform/` — the STACKIT Terraform draft (statically validated with OpenTofu)
- `execution/` — Terraform apply notes, STACKIT API scripts, manual actions, verification checks
- `migration/`, `financial/`, `assurance/`, `engineering/` — waves, work packages, data movement, cost model, evidence ledgers
- `review/` — the inputs and decisions files a customer would fill in, published unanswered
- `manifest.json` — size and SHA-256 of every file of the run; `stacktoit verify` passes on the published copy

## How the runs were made

```sh
stacktoit assess terraform/ecs/default ./aws-retail-store   # default options: full package, OpenTofu validation, online prices
stacktoit verify ./aws-retail-store                          # the folder matches its manifest
```

No `--no-validate`, no `--analysis-only`. Where a check could not run, the run says `NOT_RUN` and why; that is kept as it is.

## What these results are

A StackToIT package is a **proposal for an architect**. *Execution-ready* means a step can be carried out as written; *approved* means an architect answered every decision it rests on; *executed* means somebody ran it. Nothing here is approved or executed: no resource was created on AWS or STACKIT, and no `apply` was run. Results such as `NOT_RUN`, `MANUAL_REVIEW`, `REDESIGN`, refused steps and unpriced lines are published as the tool wrote them.

## Repository layout

```text
examples/<id>/example.json   metadata contract (schema/example.schema.json); every figure is cross-checked against output/
examples/<id>/README.md      provenance of the example
examples/<id>/output/        the run, byte for byte
site/                        templates and assets of the static site (self-hosted fonts, no third-party requests)
scripts/build-site.py        builds _site/ (standard library only)
scripts/validate.py          schema, manifest integrity, metadata-vs-output cross-checks, broken-link check of _site/
```

Adding an example means adding `examples/<id>/` with `example.json`, `README.md` and `output/`; the site, its routes and navigation follow from that.

## Licence

All rights reserved — see [LICENSE.md](LICENSE.md). The source estate of each example keeps its upstream licence (the Retail Store Sample App is published by AWS under MIT-0).
