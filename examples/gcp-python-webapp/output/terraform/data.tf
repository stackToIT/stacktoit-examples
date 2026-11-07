# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from google_sql_database_instance.postgres (database.tf:25) — REPLATFORM / MEDIUM
# flavor_id 2.4 = 2 vCPU / 4 GiB, single-node (eu01 catalogue 2026-10-18).
# REVIEW: the source disk grows by itself (disk_autoresize is on, the Cloud SQL default), so its disk_size is the size the Terraform file asks for and not necessarily the size of the data today — read the current disk size of the instance before the move and give PostgreSQL Flex at least that much; a PostgreSQL Flex storage has a fixed size and no autoscaling (pinned provider).
# backup_schedule is a default (02:00 daily): the source states no backup start time (Cloud SQL then picks one of its own).
# PITR on PostgreSQL Flex restores into a new cloned instance; backups are kept 32–90 days.
# NOT CARRIED (google_sql_database_instance.postgres): settings.user_labels — labels are metadata and the draft carries none.
# WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# retention_days: the source backup retention is not visible statically; 32 days is the STACKIT minimum (32–90).
# LEDGER network exposure: publicly accessible → instance endpoint restricted by ACL — TRANSFORMED
# NOT CARRIED (google_sql_user.django): password — the source password is not copied: STACKIT generates the user's password (stackit_postgresflex_user.password is computed, pinned provider) — hand the new one to the application.
# NOT CARRIED (google_sql_user.django): deletion_policy — stackit_postgresflex_user is deleted directly (pinned provider): ABANDON (keep the Cloud SQL user, drop it from state only) has no counterpart.
# NOT CARRIED (google_sql_user.django): name — a user name is not visible statically: create that user with stackit_postgresflex_user.
# NOT CARRIED (google_sql_database.database): deletion_policy — stackit_postgresflex_database is deleted directly (pinned provider): ABANDON (keep the Cloud SQL database, drop it from state only) has no counterpart.
# NOT CARRIED (google_sql_database.database): name — a database name (or the number of databases) is not visible statically: create that database with stackit_postgresflex_database.
# trace: TR-97904614ad56 (engineering/trace/data.md#TR-97904614ad56)
resource "stackit_postgresflex_instance" "postgres" {
  project_id = var.project_id
  name       = "postgres"
  version    = "14"
  flavor_id  = "2.4"
  storage = {
    class = var.postgresflex_storage_class
    size  = var.postgres_storage_size
  }
  backup_schedule = "0 2 * * *"
  network = {
    acl = var.postgres_allowed_cidrs
  }
  retention_days = 32
}
