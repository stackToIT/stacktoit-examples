# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from google_service_account.automation (iam.tf:54) — RECONFIGURE / MEDIUM
# Grant the permissions of the source policies as STACKIT role assignments (provider experiment "iam").
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# NOT CARRIED (google_service_account.automation): account_id — the account ID is not visible statically, or the account is declared several times: the STACKIT account is named after the source address.
# NOT CARRIED (google_service_account.automation): display_name = Automation service account — stackit_service_account has no display name, only a name besides project_id (pinned provider).
# TODO: Decide who may use the STACKIT service account written for google_service_account.automation, what it may do and which workloads run as it: the draft attaches it to nothing — google_service_account.automation is used by the workloads that run as it, by a reading that is KNOWN: google_cloud_run_v2_job.migrate (google_cloud_run_v2_job.migrate#template[0].template[0].service_account);
#   the other places that refer to it: google_cloudbuild_trigger.init, google_project_iam_member.automation_permissions, google_secret_manager_secret_iam_binding.django_admin_password, google_secret_manager_secret_iam_binding.django_settings, google_storage_bucket_iam_member.automation. Its service account is written by the draft's converter of google_service_account, not by this plan, and the plan attaches it to nothing. (phase BEFORE_PILOT, owner Identity Architect)
# TODO: 3 Google role grant(s) are not written as STACKIT role assignments: they are repeated (count or for_each), so their roles and members may differ by instance (google_project_iam_member.client_permissions; google_project_iam_member.init_permissions; google_project_iam_member.server_permissions).
# TODO: 1 Google role grant(s) are not written as STACKIT role assignments: their role is not visible statically (google_project_iam_member.automation_permissions).
# trace: TR-043d09e0acdf (engineering/trace/identity.md#TR-043d09e0acdf)
resource "stackit_service_account" "automation" {
  project_id = var.project_id
  name       = "automation"
}

# from google_service_account.client (iam.tf:48) — RECONFIGURE / MEDIUM
# Grant the permissions of the source policies as STACKIT role assignments (provider experiment "iam").
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# NOT CARRIED (google_service_account.client): account_id — the account ID is not visible statically, or the account is declared several times: the STACKIT account is named after the source address.
# NOT CARRIED (google_service_account.client): display_name = Client Frontend service account — stackit_service_account has no display name, only a name besides project_id (pinned provider).
# trace: TR-5ca70ac9e6fa (engineering/trace/identity.md#TR-5ca70ac9e6fa)
resource "stackit_service_account" "client" {
  project_id = var.project_id
  name       = "client"
}

# from google_service_account.init (iam.tf:61) — RECONFIGURE / MEDIUM
# Grant the permissions of the source policies as STACKIT role assignments (provider experiment "iam").
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# NOT CARRIED (google_service_account.init): account_id — the account ID is not visible statically, or the account is declared several times: the STACKIT account is named after the source address.
# NOT CARRIED (google_service_account.init): display_name = Jump Start App Init SA — stackit_service_account has no display name, only a name besides project_id (pinned provider).
# TODO: how many instances google_service_account.init creates is not visible statically (its count/for_each reads a variable that can be set when the source is planned, so the variable's default is not a fact of the source and is not used); this block drafts one instance — repeat it (count/for_each) for the real number and check each instance's settings.
# trace: TR-82b9a11ffa8d (engineering/trace/identity.md#TR-82b9a11ffa8d)
resource "stackit_service_account" "init" {
  project_id = var.project_id
  name       = "init"
}

# from google_service_account.server (iam.tf:42) — RECONFIGURE / MEDIUM
# Grant the permissions of the source policies as STACKIT role assignments (provider experiment "iam").
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# NOT CARRIED (google_service_account.server): account_id — the account ID is not visible statically, or the account is declared several times: the STACKIT account is named after the source address.
# NOT CARRIED (google_service_account.server): display_name = API Backend service account — stackit_service_account has no display name, only a name besides project_id (pinned provider).
# TODO: Decide who may use the STACKIT service account written for google_service_account.server, what it may do and which workloads run as it: the draft attaches it to nothing — google_service_account.server is used by the workloads that run as it, by a reading that is KNOWN: google_cloud_run_v2_service.server (google_cloud_run_v2_service.server#template[0].service_account); the other places that refer to it: google_project_iam_member.server_permissions, google_secret_manager_secret_iam_binding.django_settings, google_storage_bucket_iam_member.server.
#   Its service account is written by the draft's converter of google_service_account, not by this plan, and the plan attaches it to nothing. (phase BEFORE_PILOT, owner Identity Architect)
# trace: TR-49328bb589c6 (engineering/trace/identity.md#TR-49328bb589c6)
resource "stackit_service_account" "server" {
  project_id = var.project_id
  name       = "server"
}

# from google_cloud_run_v2_job.migrate (jobs.tf:18) — CONTAINERIZE / MEDIUM
# rule gcp.cloud_run/run-job · KB 0.394.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: Decide how google_cloud_run_v2_job.migrate gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container task, not a server an account is attached to (template[0].template[0].service_account of google_cloud_run_v2_job.migrate names google_service_account.automation).
#   no service account is attached to a workload of this source: an account attaches, but it can do nothing without its roles, and writing a role assignment from a draft has not been shown on STACKIT (it needs a right the key that tried it did not hold), so the draft grants no role and attaches no account (phase BEFORE_PILOT, owner Identity Architect)

# from google_cloud_run_v2_service.server (service.tf:17) — CONTAINERIZE / MEDIUM
# rule gcp.cloud_run/run-service · KB 0.394.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: Decide how google_cloud_run_v2_service.server gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (template[0].service_account of google_cloud_run_v2_service.server names google_service_account.server).
#   no service account is attached to a workload of this source: an account attaches, but it can do nothing without its roles, and writing a role assignment from a draft has not been shown on STACKIT (it needs a right the key that tried it did not hold), so the draft grants no role and attaches no account (phase BEFORE_PILOT, owner Identity Architect)

# from google_service_account.automation.
output "automation_email" {
  description = "The e-mail of the service account stackit_service_account.automation (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.automation.email
}

# from google_service_account.client.
output "client_email" {
  description = "The e-mail of the service account stackit_service_account.client (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.client.email
}

# from google_service_account.init.
output "init_email" {
  description = "The e-mail of the service account stackit_service_account.init (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.init.email
}

# from google_service_account.server.
output "server_email" {
  description = "The e-mail of the service account stackit_service_account.server (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.server.email
}
