# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Proposed, switched off: a STACKIT alternative for the Cloud Build trigger: starts a build on a source event, a Pub/Sub message, a webhook or by hand, with its steps, substitutions, artifacts, secrets and optional approval, which is not equal to the source.
# Difference: Nothing is converted. The same delivery is a workflow of STACKIT Git Pipelines (written for GitHub Actions; STACKIT-managed or custom runners; secrets from Secrets Manager or the repository; a manual-approval action) or the customer's own CI/CD. Trigger conditions, steps, secrets (created again, never copied), the service account (replaced by the credentials the workflow uses against STACKIT), the log destination and the approval are written again by a person.
# To decide: Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files.
# Written for google_cloudbuild_trigger.placeholder.
# NOT CARRIED (google_cloudbuild_trigger.placeholder): the source repeats this resource and the module writes it once: give each instance its own design
# NOT CARRIED (google_cloudbuild_trigger.placeholder): build.options.logging: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add
# NOT CARRIED (google_cloudbuild_trigger.placeholder): build.step.env: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add
# NOT CARRIED (google_cloudbuild_trigger.placeholder): build.step.id: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add
# NOT CARRIED (google_cloudbuild_trigger.placeholder): build.step.name: the name of the resource on STACKIT is the customer's value, and nothing is copied from the source name
# NOT CARRIED (google_cloudbuild_trigger.placeholder): description: the module takes no value of the source: give the value in the values if it is wanted
# NOT CARRIED (google_cloudbuild_trigger.placeholder): location: a region of the source is not copied: the module runs in the region the provider of the draft sets, or the one given in the values where it has a setting for it
# NOT CARRIED (google_cloudbuild_trigger.placeholder): name: the name of the resource on STACKIT is the customer's value, and nothing is copied from the source name
# NOT CARRIED (google_cloudbuild_trigger.placeholder): pubsub_config.topic: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add
# NOT CARRIED (google_cloudbuild_trigger.placeholder): service_account: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_git and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which pipelines are still needed, where they run (STACKIT Git Pipelines or the customer's own CI/CD), how each trigger, step, secret and approval is written again, and who owns the workflow files.
# TARGET MATURITY: BETA — the pinned STACKIT provider marks stackit_git as beta: "may be subject to breaking changes in the future" (enable_beta_resources is set in terraform.tf).
resource "stackit_git" "this" {
  name       = var.values.name
  project_id = var.project_id
}
