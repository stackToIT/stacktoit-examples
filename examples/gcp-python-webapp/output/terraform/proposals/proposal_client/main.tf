# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Proposed, switched off: a STACKIT alternative for the static web hosting site, which is not equal to the source.
# Difference: Static files are published into an Object Storage bucket by a pipeline, and a CDN distribution (a beta resource) with the bucket as origin serves them on a custom domain; the redirects of the site become redirect rules of the distribution. Custom response headers, rewrites to Cloud Run services or Cloud Functions, preview channels and the release history have no counterpart and are restated in the pipeline or in the application.
# To decide: Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta.
# Written for google_firebase_hosting_site.client.
# NOT CARRIED (google_firebase_hosting_site.client): the source repeats this resource and the module writes it once: give each instance its own design
# NOT CARRIED (google_firebase_hosting_site.client): project: the module is written for the project of the draft
# NOT CARRIED (google_firebase_hosting_site.client): site_id: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (objectstorage_bucket_name, cdn_distribution_config, cdn_custom_domain_distribution_id, cdn_custom_domain_name), and every other setting is the customer's to add

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_objectstorage_bucket and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta.
# The row names more than one resource: this block is written only when write_objectstorage_bucket is true, and the module never writes more than the customer asks for.
resource "stackit_objectstorage_bucket" "this" {
  count      = var.values.write_objectstorage_bucket ? 1 : 0
  name       = var.values.objectstorage_bucket_name
  project_id = var.project_id
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_cdn_distribution and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta.
# The row names more than one resource: this block is written only when write_cdn_distribution is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: BETA — the pinned STACKIT provider marks stackit_cdn_distribution as beta: "may be subject to breaking changes in the future" (enable_beta_resources is set in terraform.tf).
resource "stackit_cdn_distribution" "this" {
  count = var.values.write_cdn_distribution ? 1 : 0
  config = {
    backend = {
      type = var.values.cdn_distribution_config.backend.type
    }
    regions = var.values.cdn_distribution_config.regions
  }
  project_id = var.project_id
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_cdn_custom_domain and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which bucket is the origin, which domain the distribution serves, and how rewrites and previews are replaced. The CDN resources are beta.
# The row names more than one resource: this block is written only when write_cdn_custom_domain is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: BETA — the pinned STACKIT provider marks stackit_cdn_custom_domain as beta: "may be subject to breaking changes in the future" (enable_beta_resources is set in terraform.tf).
resource "stackit_cdn_custom_domain" "this" {
  count           = var.values.write_cdn_custom_domain ? 1 : 0
  distribution_id = var.values.cdn_custom_domain_distribution_id
  name            = var.values.cdn_custom_domain_name
  project_id      = var.project_id
}
