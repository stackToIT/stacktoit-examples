# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from google_storage_bucket.media (storage.tf:17) — RECONFIGURE / MEDIUM
# WARNING gcs-force-destroy: force_destroy lets Terraform delete the bucket together with its objects.
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# NOT CARRIED (google_storage_bucket.media): storage_class = REGIONAL — stackit_objectstorage_bucket has a name and object_lock only (pinned provider): the bucket's storage class, Autoclass, hierarchical-namespace and requester-pays settings are not generated.
# NOT CARRIED (google_storage_bucket.media): force_destroy = true — stackit_objectstorage_bucket has no force-destroy override (pinned provider): deleting a bucket that still holds objects behaves as STACKIT's Object Storage API defines it — empty the bucket (or migrate its objects) before it is destroyed.
# NOT CARRIED (google_storage_bucket_iam_member.automation): member, role = roles/storage.admin — the draft of google_storage_bucket.media does not carry this one member's role on the Cloud Storage bucket. Proposed, switched off until it is decided: proposals/proposal_automation, switch proposal_automation_enabled.
# NOT CARRIED (google_storage_bucket_iam_member.server): member, role = roles/storage.admin — the draft of google_storage_bucket.media does not carry this one member's role on the Cloud Storage bucket. Proposed, switched off until it is decided: proposals/proposal_server, switch proposal_server_enabled.
# trace: TR-03d7fb936653 (engineering/trace/storage.md#TR-03d7fb936653)
resource "stackit_objectstorage_bucket" "media" {
  project_id = var.project_id
  name       = var.media_bucket_name
}
