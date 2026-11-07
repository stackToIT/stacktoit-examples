# STACKIT target draft

> Generated migration draft by StackToIT — architect review required. Not for apply without review.

Run `6f8f72b2-1c34-4cfc-8483-344c41245364` · source digest `sha256:19bfed642d5789ccada81b91d5c36e33175dcafd66dc46b1644ffa105d020000`

Generated for STACKIT Terraform provider `0.121.0`. Fill the variables without defaults (fill the copy of `target-values-template.tfvars` StackToIT put in the review folder and run StackToIT again, which writes the values it takes into this folder, or use your own variables file), then run `tofu init && tofu validate && tofu plan` against a test project. StackToIT never runs apply.

| | |
|---|---:|
| Units generated | 11 |
| Units that need no STACKIT resource | 0 |
| Units proposed, switched off | 4 |
| Units left for the architect | 1 |
| Variables to fill or confirm | 13 |

Each block keeps a short comment: where it comes from, why its values are what they are, what is not carried and which decision is open. Its last line, `# trace: TR-…`, names the section of the trace file of this draft file in the report folder (`engineering/trace/<draft file>.md#TR-…`, listed in `engineering/trace-index.csv`) that holds the whole comment the generators wrote: the rule and the knowledge-base stamp, the references with their digests, the evidence of each chosen value and the reason of each attribute that is not written. A comment line that is shortened ends with `… (full text: engineering/trace/<draft file>.md)`, the file that holds it whole.

## Enable these services first

STACKIT services are enabled per project and region; the portal shows a disabled one as "not enabled in your region". Enable the services this draft uses before apply: Kubernetes Engine, Object Storage, PostgreSQL Flex, RabbitMQ, Secrets Manager. Enabling Kubernetes Engine also enables IaaS, Load Balancer and Network Area. (A plan with -refresh=false does not need them; whether apply enables a service by itself is not verified.)

## Target lifecycle

STACKIT publishes dates for the lifecycle of some capabilities this draft lands on. A state below is derived from those dates only, as of the day the sources were read; this draft does not read the clock, so compare the dates with today. The assessment's engineering/architect-report.md, section "Target lifecycle", has the dates, the effects and the sources.

- **SKE Kubernetes versions**, as of 2026-11-03 (the day the sources were read; not vouched for after 2027-02-01): 1.36 SUPPORTED, 1.35 UNKNOWN, 1.34 EXPIRED, 1.33 EXPIRED, 1.32 EXPIRED. Suitable as a landing in production: 1.36.

## Target security checklist

Each row is filled from a check or a table at generation, not written by hand. A row is evidence of what the generated files hold, not of what you will add to them.

| Check | Result |
|---|---|
| Generated static secrets | **0** — the credential-pattern table of StackToIT (set v5) found no literal credential in the 37 generated files that are not Markdown notes; a secret input is a `sensitive = true` variable without a default |
| Sensitive variables | **0** of 13 declared variables are `sensitive = true`: none. Pass them with `TF_VAR_<name>`, never in a committed file |
| Secrets the provider writes into the state | written by the provider at apply: `stackit_secretsmanager_user` (`password`). `sensitive` hides a value from the plan output only; the state holds it in plain text, so the state is itself a secret (the pinned provider schema) |
| Write-only or ephemeral alternative | none: the pinned provider schema has no write-only or ephemeral form for these attributes, so the values stay in the state: keep the state encrypted (OpenTofu state encryption or an encrypted backend) with read access limited to the pipeline |
| Provider authentication | Authenticate the provider with Workload Identity Federation (`use_oidc = true` and `service_account_email`, a short-lived OIDC token exchanged for a STACKIT access token) instead of a long-lived service account key: the provider documents it as the way that "eliminates the need for long-lived secrets" in CI/CD (the STACKIT provider documentation, index page, section "Workload Identity Federation", and its guide "Workload Identity Federation"; knowledge-base evidence, not in this folder). |
| Terraform state backend | The draft declares no backend, so its state is a local file until you configure one. The provider documentation states that `use_lockfile = true` on the S3 backend has no effect with a STACKIT Object Storage bucket, and for state locking it points to a PostgreSQL backend (the STACKIT provider documentation, index page, section "Backend configuration"; knowledge-base evidence, not in this folder). Do not rely on locking with an S3 backend on STACKIT Object Storage: run apply from one job at a time, or use the PostgreSQL backend the provider points to. StackToIT did not test locking on any backend. |

## Generated

Resources written to the .tf files in this folder.

| Source | Class | Generated |
|---|---|---|
| `google_service_account.automation` | RECONFIGURE / MEDIUM | `stackit_service_account.automation` |
| `google_service_account.client` | RECONFIGURE / MEDIUM | `stackit_service_account.client` |
| `google_service_account.init` | RECONFIGURE / MEDIUM | `stackit_service_account.init` |
| `google_service_account.server` | RECONFIGURE / MEDIUM | `stackit_service_account.server` |
| `google_cloud_run_v2_job.migrate` | CONTAINERIZE / MEDIUM | `stackit_ske_cluster.containers` — Kubernetes manifests kubernetes/migrate/manifests.yaml on stackit_ske_cluster.containers |
| `google_cloud_run_v2_service.server` | CONTAINERIZE / MEDIUM | `stackit_ske_cluster.containers` — Kubernetes manifests kubernetes/server/manifests.yaml on stackit_ske_cluster.containers |
| `google_pubsub_topic.faux` | REPLATFORM / MEDIUM | `stackit_rabbitmq_instance.messaging` — shared instance |
| `google_secret_manager_secret.django_admin_password` | RECONFIGURE / MEDIUM | `stackit_secretsmanager_instance.migrated_secrets` — shared instance |
| `google_secret_manager_secret.django_settings` | RECONFIGURE / MEDIUM | `stackit_secretsmanager_instance.migrated_secrets` — shared instance |
| `google_sql_database_instance.postgres` | REPLATFORM / MEDIUM | `stackit_postgresflex_instance.postgres` |
| `google_storage_bucket.media` | RECONFIGURE / MEDIUM | `stackit_objectstorage_bucket.media` — copy objects with rclone; clients switch to S3 endpoint and keys |

## Kubernetes manifests — not Terraform

The workloads of ECS services are Kubernetes manifests, not Terraform: `tofu validate` and `tofu apply` do not read them. Apply each file with the kubeconfig of the SKE cluster this draft creates (`kubectl apply -n <namespace> -f <file>`). The header of each file lists the required inputs (a `REQUIRED_` token is refused by the API server in a field that is not a string, such as a number of pods, and accepted in a string field such as an image: replace every token before you apply), the secrets to create and what is not carried.

How to get the kubeconfig of the cluster is a DEFINED step, not something this draft does: `handover/cluster-access/kubeconfig.md` lists the commands (the STACKIT CLI; no `stackit_ske_kubeconfig` is drafted because the admin kubeconfig would be kept in the Terraform state).

- `kubernetes/migrate/manifests.yaml`
- `kubernetes/server/manifests.yaml`

## Not carried for any unit

- **Tags and labels** of the source resources: STACKIT resources take `labels`, this draft sets none. Behaviour that selects resources by tag (backup selections, IAM conditions, cost allocation) must be rebuilt.
- **Placement**: every resource is created in `var.region` inside the project `var.project_id`. A source spread over several regions, resource groups or projects is collapsed into one: each resource that sets one of those values says so in a NOT CARRIED line next to its block.

## Proposed, switched off

A STACKIT alternative for what STACKIT does not carry as the source does, written as a module that is off: `proposals.tf` holds its switch, and a plan of this draft holds nothing of it until a person reads the module, gives it its values and sets the switch to true. It is not equal to the source and is not counted as generated.

| Source | Module and switch | What differs | What you decide |
|---|---|---|---|
| google_cloudbuild_trigger.activategcb | `proposals/proposal_activategcb`, `proposal_activategcb_enabled` | Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person. | Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files. |
| google_cloudbuild_trigger.init | `proposals/proposal_init`, `proposal_init_enabled` | Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person. | Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files. |
| google_cloudbuild_trigger.placeholder | `proposals/proposal_placeholder`, `proposal_placeholder_enabled` | Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person. | Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files. |
| google_firebase_hosting_site.client | `proposals/proposal_client`, `proposal_client_enabled` | Static files are published into an Object Storage bucket by a pipeline, and a CDN distribution (a beta resource) with the bucket as origin serves them on a custom domain; the redirects of the site become redirect rules of the distribution. Custom response headers, rewrites to Cloud Run services or Cloud Functions, preview channels and the release history have no counterpart and are restated in the pipeline or in the application. | Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta. |
| google_secret_manager_secret_iam_binding.django_admin_password (beside the draft of google_secret_manager_secret.django_admin_password) | `proposals/proposal_django_admin_password`, `proposal_django_admin_password_enabled` | A STACKIT role assignment is not a grant on the Secret Manager secret. It gives one user, group or service account one STACKIT role on a whole project, folder or organisation. The role is a set of STACKIT permissions, not the Google role, and no table maps one to the other. It has no condition and no public member, so what the grant gave to a Google group, a domain, a federated identity or everyone is named again, and the access reaches more than the Secret Manager secret. A binding on a secret group applies to every secret in the group, so it is wider than a grant on one secret unless the secret has a group of its own, and its roles are Secrets Manager roles. The binding was authoritative for its role: STACKIT role assignments are additive, so a person who holds the role through another assignment keeps it, and removing such people is a step of a person. | Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant. Whether people who hold the role through another assignment keep it. |
| google_secret_manager_secret_iam_binding.django_settings (beside the draft of google_secret_manager_secret.django_settings) | `proposals/proposal_django_settings`, `proposal_django_settings_enabled` | A STACKIT role assignment is not a grant on the Secret Manager secret. It gives one user, group or service account one STACKIT role on a whole project, folder or organisation. The role is a set of STACKIT permissions, not the Google role, and no table maps one to the other. It has no condition and no public member, so what the grant gave to a Google group, a domain, a federated identity or everyone is named again, and the access reaches more than the Secret Manager secret. A binding on a secret group applies to every secret in the group, so it is wider than a grant on one secret unless the secret has a group of its own, and its roles are Secrets Manager roles. The binding was authoritative for its role: STACKIT role assignments are additive, so a person who holds the role through another assignment keeps it, and removing such people is a step of a person. | Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant. Whether people who hold the role through another assignment keep it. |
| google_storage_bucket_iam_member.automation (beside the draft of google_storage_bucket.media) | `proposals/proposal_automation`, `proposal_automation_enabled` | A STACKIT credentials group is not a grant on the Cloud Storage bucket. It is the principal that a bucket policy names, a set of S3 keys with no Google identity behind it, and by itself it gives no access to the bucket and takes none away. The statement that grants it something is a statement of the bucket policy, in the policy language of STACKIT (a credentials group or * as the principal, S3 actions, five condition keys), which no Terraform resource sets. The Google role is not mapped to S3 actions by any table, the condition of the grant has no counterpart unless it can be written with those five condition keys, and a Google group, a domain, a federated identity and allUsers or allAuthenticatedUsers are named again as credentials groups or as *. | Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it. |
| google_storage_bucket_iam_member.server (beside the draft of google_storage_bucket.media) | `proposals/proposal_server`, `proposal_server_enabled` | A STACKIT credentials group is not a grant on the Cloud Storage bucket. It is the principal that a bucket policy names, a set of S3 keys with no Google identity behind it, and by itself it gives no access to the bucket and takes none away. The statement that grants it something is a statement of the bucket policy, in the policy language of STACKIT (a credentials group or * as the principal, S3 actions, five condition keys), which no Terraform resource sets. The Google role is not mapped to S3 actions by any table, the condition of the grant has no counterpart unless it can be written with those five condition keys, and a Google group, a domain, a federated identity and allUsers or allAuthenticatedUsers are named again as credentials groups or as *. | Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it. |

## Left for the architect

Design decisions StackToIT does not make (REDESIGN, MANUAL_REVIEW, BLOCKED), targets without a STACKIT Terraform resource, objects that are not STACKIT resources, or no generator yet; and a conditional unit that is switched off as the variables stand (listed with the note "Decided when OpenTofu plans"): it has no resource now and is the architect's to decide once the variable is set. See engineering/architect-report.md for the reasoning.

| Source | Class | Why |
|---|---|---|
| `google_firebase_project.default` | MANUAL_REVIEW / LOW | STACKIT has no mobile or web application backend platform: none of the 115 resource types of the pinned STACKIT provider is one (0 hits for firebase in resource names, descriptions and attributes, checked 2026-11-05), and the product list at docs.stackit.cloud/products/ (read 2026-11-05) names none. |

## Support resources and execution helpers

These source resources are not units of the assessment and the draft writes no block of its own for them. A support resource is configuration other resources read (a target group, a subnet group, a policy attachment, a backup vault); an execution helper (a random value, a time delay, a null resource) belongs to the Terraform run and has no counterpart in the cloud. They are listed so that no resource of the source is missing from the package. The critical settings a support resource states itself are listed for a person's decision in `engineering/architect-report.md` (Support resources) and `engineering/review.csv` (the rows whose domain is support); a resource without a critical setting has none listed. The execution plan binds each of them to the unit that reads the resource (`execution-plan.json` coverage.units.support_settings, and `assurance/critical-semantics.json`): carried by that unit's OpenTofu step where its block writes the setting as the source states it (confirm only), else a gap its step names; none is a step of its own. A value a helper generates when OpenTofu applies (a password, a key) exists only in the state of the source: the draft does not carry it.

| Source | Kind | Read by |
|---|---|---|
| `google_cloud_run_service_iam_policy.server_noauth` | support resource | no unit of the source reads it |
| `google_project_iam_member.automation_permissions` | support resource | no unit of the source reads it |
| `google_project_iam_member.client_permissions` | support resource | no unit of the source reads it |
| `google_project_iam_member.init_permissions` | support resource | no unit of the source reads it |
| `google_project_iam_member.server_permissions` | support resource | no unit of the source reads it |
| `module.project_services.google_project_service.project_services` | support resource | no unit of the source reads it |
| `random_id.suffix` | execution helper | `google_cloud_run_v2_job.migrate`, `google_cloud_run_v2_service.server`, `google_cloudbuild_trigger.activategcb`, `google_cloudbuild_trigger.init`, `google_cloudbuild_trigger.placeholder` and 10 more |
| `random_password.database_user_password` | execution helper | `google_sql_database_instance.postgres` |
| `random_password.django_admin_password` | execution helper | `google_secret_manager_secret.django_admin_password` |
| `random_password.django_secret_key` | execution helper | `google_secret_manager_secret.django_settings` |
| `time_sleep.init_permissions_propagation` | execution helper | no unit of the source reads it |

## Semantic ledger

The security or resilience properties the draft tracks in this ledger, and what it does with each: PRESERVED, TRANSFORMED (kept another way), UNSUPPORTED (STACKIT has no equivalent), REVIEW (an architect decides or fills in a value). One row can close several critical semantics of the unit (the ones that name it as `ledger:<property>` in engineering/architect-report.md): a semantic is carried when its row is PRESERVED or TRANSFORMED and stays open when the row is REVIEW or UNSUPPORTED. The other critical semantics of a unit are decided in engineering/architect-report.md, not here.

| Source | Property | Source value | Draft | Status |
|---|---|---|---|---|
| `google_cloud_run_v2_job.migrate` | workload identity | the Google service account of the revision | no identity in the manifests: the pods run as the default ServiceAccount until a person decides | **REVIEW** |
| `google_cloud_run_v2_service.server` | workload identity | the Google service account of the revision | no identity in the manifests: the pods run as the default ServiceAccount until a person decides | **REVIEW** |
| `google_sql_database_instance.postgres` | network exposure | publicly accessible | instance endpoint restricted by ACL | **TRANSFORMED** |
