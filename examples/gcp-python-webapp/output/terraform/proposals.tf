# Proposals: a STACKIT alternative for what STACKIT does not carry as the source does, each a module that is switched off. Nothing here is part of a plan of this draft until a person reads the module, gives it its values and sets its switch to true.

# The switch of the proposal proposal_activategcb: false writes nothing of it into a plan.
variable "proposal_activategcb_enabled" {
  type        = bool
  description = "Set to true to make the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_activategcb: null while it is off; every attribute is required once it is on.
variable "proposal_activategcb" {
  type = object({
    name = string
  })
  description = "The values of the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval, which is not equal to the source.
# Difference: Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person.
# To decide: Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files.
module "proposal_activategcb" {
  source     = "./proposals/proposal_activategcb"
  count      = var.proposal_activategcb_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_activategcb
}

# The switch of the proposal proposal_init: false writes nothing of it into a plan.
variable "proposal_init_enabled" {
  type        = bool
  description = "Set to true to make the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_init: null while it is off; every attribute is required once it is on.
variable "proposal_init" {
  type = object({
    name = string
  })
  description = "The values of the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval, which is not equal to the source.
# Difference: Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person.
# To decide: Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files.
module "proposal_init" {
  source     = "./proposals/proposal_init"
  count      = var.proposal_init_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_init
}

# The switch of the proposal proposal_placeholder: false writes nothing of it into a plan.
variable "proposal_placeholder_enabled" {
  type        = bool
  description = "Set to true to make the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_placeholder: null while it is off; every attribute is required once it is on.
variable "proposal_placeholder" {
  type = object({
    name = string
  })
  description = "The values of the proposed Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval, which is not equal to the source.
# Difference: Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person.
# To decide: Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files.
module "proposal_placeholder" {
  source     = "./proposals/proposal_placeholder"
  count      = var.proposal_placeholder_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_placeholder
}

# The switch of the proposal proposal_client: false writes nothing of it into a plan.
variable "proposal_client_enabled" {
  type        = bool
  description = "Set to true to make the proposed static web hosting site replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_client: null while it is off; every attribute is required once it is on.
variable "proposal_client" {
  type = object({
    write_objectstorage_bucket        = bool
    objectstorage_bucket_name         = string
    write_cdn_distribution            = bool
    cdn_distribution_config           = object({ backend = object({ type = string }), regions = list(string) })
    write_cdn_custom_domain           = bool
    cdn_custom_domain_distribution_id = string
    cdn_custom_domain_name            = string
  })
  description = "The values of the proposed static web hosting site replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the static web hosting site, which is not equal to the source.
# Difference: Static files are published into an Object Storage bucket by a pipeline, and a CDN distribution (a beta resource) with the bucket as origin serves them on a custom domain; the redirects of the site become redirect rules of the distribution. Custom response headers, rewrites to Cloud Run services or Cloud Functions, preview channels and the release history have no counterpart and are restated in the pipeline or in the application.
# To decide: Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta.
module "proposal_client" {
  source     = "./proposals/proposal_client"
  count      = var.proposal_client_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_client
}

# The switch of the proposal proposal_django_admin_password: false writes nothing of it into a plan.
variable "proposal_django_admin_password_enabled" {
  type        = bool
  description = "Set to true to make the proposed the members of one role on the Secret Manager secret replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_django_admin_password: null while it is off; every attribute is required once it is on.
variable "proposal_django_admin_password" {
  type = object({
    write_authorization_project_role_assignment             = bool
    authorization_project_role_assignment_resource_id       = string
    authorization_project_role_assignment_role              = string
    authorization_project_role_assignment_subject           = string
    write_authorization_folder_role_assignment              = bool
    authorization_folder_role_assignment_resource_id        = string
    authorization_folder_role_assignment_role               = string
    authorization_folder_role_assignment_subject            = string
    write_authorization_organization_role_assignment        = bool
    authorization_organization_role_assignment_resource_id  = string
    authorization_organization_role_assignment_role         = string
    authorization_organization_role_assignment_subject      = string
    write_secretsmanager_secret_group_role_binding_v1       = bool
    secretsmanager_secret_group_role_binding_v1_resource_id = string
    secretsmanager_secret_group_role_binding_v1_role        = string
    secretsmanager_secret_group_role_binding_v1_subject     = string
    write_secretsmanager_instance_role_binding_v1           = bool
    secretsmanager_instance_role_binding_v1_resource_id     = string
    secretsmanager_instance_role_binding_v1_role            = string
    secretsmanager_instance_role_binding_v1_subject         = string
  })
  description = "The values of the proposed the members of one role on the Secret Manager secret replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the the members of one role on the Secret Manager secret, which is not equal to the source.
# Difference: A STACKIT role assignment is not a grant on the Secret Manager secret. It gives one user, group or service account one STACKIT role on a whole project, folder or organisation. The role is a set of STACKIT permissions, not the Google role, and no table maps one to the other. It has no condition and no public member, so what the grant gave to a Google group, a domain, a federated identity or everyone is named again, and the access reaches more than the Secret Manager secret.
#   A binding on a secret group applies to every secret in the group, so it is wider than a grant on one secret unless the secret has a group of its own, and its roles are Secrets Manager roles. The binding was authoritative for its role: STACKIT role assignments are additive, so a person who holds the role through another assignment keeps it, and removing such people is a step of a person.
# To decide: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
module "proposal_django_admin_password" {
  source     = "./proposals/proposal_django_admin_password"
  count      = var.proposal_django_admin_password_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_django_admin_password
}

# The switch of the proposal proposal_django_settings: false writes nothing of it into a plan.
variable "proposal_django_settings_enabled" {
  type        = bool
  description = "Set to true to make the proposed the members of one role on the Secret Manager secret replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_django_settings: null while it is off; every attribute is required once it is on.
variable "proposal_django_settings" {
  type = object({
    write_authorization_project_role_assignment             = bool
    authorization_project_role_assignment_resource_id       = string
    authorization_project_role_assignment_role              = string
    authorization_project_role_assignment_subject           = string
    write_authorization_folder_role_assignment              = bool
    authorization_folder_role_assignment_resource_id        = string
    authorization_folder_role_assignment_role               = string
    authorization_folder_role_assignment_subject            = string
    write_authorization_organization_role_assignment        = bool
    authorization_organization_role_assignment_resource_id  = string
    authorization_organization_role_assignment_role         = string
    authorization_organization_role_assignment_subject      = string
    write_secretsmanager_secret_group_role_binding_v1       = bool
    secretsmanager_secret_group_role_binding_v1_resource_id = string
    secretsmanager_secret_group_role_binding_v1_role        = string
    secretsmanager_secret_group_role_binding_v1_subject     = string
    write_secretsmanager_instance_role_binding_v1           = bool
    secretsmanager_instance_role_binding_v1_resource_id     = string
    secretsmanager_instance_role_binding_v1_role            = string
    secretsmanager_instance_role_binding_v1_subject         = string
  })
  description = "The values of the proposed the members of one role on the Secret Manager secret replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the the members of one role on the Secret Manager secret, which is not equal to the source.
# Difference: A STACKIT role assignment is not a grant on the Secret Manager secret. It gives one user, group or service account one STACKIT role on a whole project, folder or organisation. The role is a set of STACKIT permissions, not the Google role, and no table maps one to the other. It has no condition and no public member, so what the grant gave to a Google group, a domain, a federated identity or everyone is named again, and the access reaches more than the Secret Manager secret.
#   A binding on a secret group applies to every secret in the group, so it is wider than a grant on one secret unless the secret has a group of its own, and its roles are Secrets Manager roles. The binding was authoritative for its role: STACKIT role assignments are additive, so a person who holds the role through another assignment keeps it, and removing such people is a step of a person.
# To decide: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
module "proposal_django_settings" {
  source     = "./proposals/proposal_django_settings"
  count      = var.proposal_django_settings_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_django_settings
}

# The switch of the proposal proposal_automation: false writes nothing of it into a plan.
variable "proposal_automation_enabled" {
  type        = bool
  description = "Set to true to make the proposed one member's role on the Cloud Storage bucket replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_automation: null while it is off; every attribute is required once it is on.
variable "proposal_automation" {
  type = object({
    name = string
  })
  description = "The values of the proposed one member's role on the Cloud Storage bucket replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the one member's role on the Cloud Storage bucket, which is not equal to the source.
# Difference: A STACKIT credentials group is not a grant on the Cloud Storage bucket. It is the principal that a bucket policy names, a set of S3 keys with no Google identity behind it, and by itself it gives no access to the bucket and takes none away. The statement that grants it something is a statement of the bucket policy, in the policy language of STACKIT (a credentials group or * as the principal, S3 actions, five condition keys), which no Terraform resource sets.
#   The Google role is not mapped to S3 actions by any table, the condition of the grant has no counterpart unless it can be written with those five condition keys, and a Google group, a domain, a federated identity and allUsers or allAuthenticatedUsers are named again as credentials groups or as *.
# To decide: Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it.
module "proposal_automation" {
  source     = "./proposals/proposal_automation"
  count      = var.proposal_automation_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_automation
}

# The switch of the proposal proposal_server: false writes nothing of it into a plan.
variable "proposal_server_enabled" {
  type        = bool
  description = "Set to true to make the proposed one member's role on the Cloud Storage bucket replacement part of the plan, after reading the module."
  default     = false
}

# The values of the proposal proposal_server: null while it is off; every attribute is required once it is on.
variable "proposal_server" {
  type = object({
    name = string
  })
  description = "The values of the proposed one member's role on the Cloud Storage bucket replacement: nothing is taken from the source."
  default     = null
}

# Proposed, switched off: a STACKIT alternative for the one member's role on the Cloud Storage bucket, which is not equal to the source.
# Difference: A STACKIT credentials group is not a grant on the Cloud Storage bucket. It is the principal that a bucket policy names, a set of S3 keys with no Google identity behind it, and by itself it gives no access to the bucket and takes none away. The statement that grants it something is a statement of the bucket policy, in the policy language of STACKIT (a credentials group or * as the principal, S3 actions, five condition keys), which no Terraform resource sets.
#   The Google role is not mapped to S3 actions by any table, the condition of the grant has no counterpart unless it can be written with those five condition keys, and a Google group, a domain, a federated identity and allUsers or allAuthenticatedUsers are named again as credentials groups or as *.
# To decide: Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it.
module "proposal_server" {
  source     = "./proposals/proposal_server"
  count      = var.proposal_server_enabled ? 1 : 0
  project_id = var.project_id
  values     = var.proposal_server
}
