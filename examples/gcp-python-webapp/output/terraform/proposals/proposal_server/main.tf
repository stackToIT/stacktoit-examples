# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Proposed, switched off: a STACKIT alternative for the one member's role on the Cloud Storage bucket, which is not equal to the source.
# Difference: A STACKIT credentials group is not a grant on the Cloud Storage bucket. It is the principal that a bucket policy names, a set of S3 keys with no Google identity behind it, and by itself it gives no access to the bucket and takes none away. The statement that grants it something is a statement of the bucket policy, in the policy language of STACKIT (a credentials group or * as the principal, S3 actions, five condition keys), which no Terraform resource sets.
#   The Google role is not mapped to S3 actions by any table, the condition of the grant has no counterpart unless it can be written with those five condition keys, and a Google group, a domain, a federated identity and allUsers or allAuthenticatedUsers are named again as credentials groups or as *.
# To decide: Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it.
# Written for google_storage_bucket_iam_member.server, beside the draft of google_storage_bucket.media, which it changes nothing of.
# NOT CARRIED (google_storage_bucket_iam_member.server): member: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add
# NOT CARRIED (google_storage_bucket_iam_member.server): role: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (name), and every other setting is the customer's to add

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_objectstorage_credentials_group and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which credentials group stands for each member of the grant, which S3 actions of the bucket policy give the same people the access they need and no more than the Google role gave, what becomes of the condition, of public members (allUsers, allAuthenticatedUsers), of Google groups, domains and federated identities, and whether the grant ends with the Cloud Storage bucket when it has no replacement. Which bucket the grant is on, because the scan does not hold it.
resource "stackit_objectstorage_credentials_group" "this" {
  name       = var.values.name
  project_id = var.project_id
}
