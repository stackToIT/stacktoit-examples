# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Target: stackit provider 0.121.0; knowledge base 0.420.0

# TODO: node[module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks].name: Choose a static label and send the name of module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks (and of its streams) from its log producers as the value of that label (the manual action below)
# NOT CARRIED (module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks): node[module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks].retention_in_days — the source keeps its logs for ever (it states no period, or 0); a Logs instance keeps at most 180 days, so the logs of this source are kept for 180 days here and anything older has to be archived elsewhere (for example in Object Storage) if it must be kept
# TODO: Configure a cold-storage log flow for module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks: send a copy of its logs, in parallel to the Logs instance stackit_logs_instance.logs_retention_180d, to a long-term store (for example a separate Object Storage bucket) that keeps them for the retention beyond 180 days
#   — the source keeps its logs for ever and a STACKIT Logs instance keeps at most 180 days (retention beyond 180 days is not supported by the managed service): the first 180 days are kept in the Logs instance, and the longer retention is an archive outside it, which STACKIT recommends as a cold-storage approach (a stream of the log data to a low-cost long-term store in parallel to Logs). The plan creates no archive store, configures no stream and sets no retention of the archive.
#   The step exists only when the decision about the logs beyond 180 days chooses the archive; where the requirement is more than 180 days inside STACKIT Logs with no external archive, the archive is rejected and the migration cannot meet that requirement with STACKIT Logs alone (phase CUTOVER_PREREQUISITE, owner Platform Architect)
# TODO: Choose a static label and send the name of module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks (and of its streams) from its log producers as the value of that label — STACKIT Logs has no log group or stream object that can hold a name, only labels the shipper sends (no-log-group-or-stream-object); the plan chooses no label key and reconfigures no producer (phase CUTOVER_PREREQUISITE, owner Platform Architect)
# TODO: Before any log source writes to stackit_logs_instance.logs_retention_180d: create a write access token for the instance (stackit_logs_access_token with the permission write), and point the shipper at the instance's ingest_url (Loki API) or ingest_otlp_url (OpenTelemetry) from an address var.logs_acl_retention_180d admits — the plan generates no access token: the token is a credential written to the state, its lifetime (unset, it never expires) and its permissions are choices the source does not state, and one token belongs to one instance;
#   the access list is var.logs_acl_retention_180d, a required input with no default the person gives before the instance is planned: what an instance with no ACL entry allows is not established, so the plan neither leaves it out nor accepts an empty list (phase CUTOVER_PREREQUISITE, owner Platform Architect)
# TODO: decision DEC-OPS-STACKITLOGS-RETENTION-OVER-180-DAYS (alias `stackitlogs:module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks:retention_over_180_days`) — Decide whether the logs of module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks older than 180 days are kept in an archive outside the Logs instance — the source keeps its logs for ever and a STACKIT Logs instance keeps at most 180 days, so the instance drafted for it (stackit_logs_instance.logs_retention_180d) holds only the last 180 days; logs older than that exist only if a person configures an archive beside it.
#   Choose the archive if the workload needs them; reject it if the requirement is that more than 180 days stay inside STACKIT Logs with no external archive, which STACKIT Logs alone cannot meet (phase CUTOVER_PREREQUISITE)
# NOT CARRIED (module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks): module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks (LOG_GROUP) — group not produced: its logs go to the Logs instance stackit_logs_instance.logs_retention_180d … (full text: engineering/trace/observability.md)
# NOT CARRIED (module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks): module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks retention_in_days — no equivalent on STACKIT: the instance keeps its logs for 180 days at most; older logs are not kept (source: keeps its logs for ever)
# module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# replaces: module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks
# trace: TR-c0888ccac0ab (engineering/trace/observability.md#TR-c0888ccac0ab)
resource "stackit_logs_instance" "logs_retention_180d" {
  project_id     = var.project_id
  display_name   = "logs-retention-180d"
  retention_days = 180
  acl            = var.logs_acl_retention_180d
}

# from module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs (../../lib/ecs/eventbridge.tf:38) — RECONFIGURE / LOW
# a resource policy lets an AWS service principal put log events; STACKIT Logs authenticates each producer with a bearer token instead, and this token may only write (permissions = ["write"]), whatever the policy document allowed.
# TODO: issue the token to each log-shipping producer from the sensitive access_token attribute (read it from the state, never write it into a file); the draft sets no lifetime, as the policy had no expiry: set lifetime (days) and rotate_when_changed to your rotation policy.
# NOT CARRIED (module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs): policy_document — the policy document (the principals, actions and conditions) has no counterpart in STACKIT Logs: access is the token, one per producer; the scope of the policy (resource_arn: one log group or the account) is the Logs instance the token belongs to.
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# TODO: how many instances module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs creates is not visible statically (its count/for_each reads a variable that can be set when the source is planned, so the variable's default is not a fact of the source and is not used): count is var.eventbridge_ecs_count — set it to the real number and check each instance's settings.
# trace: TR-91d13053b855 (engineering/trace/observability.md#TR-91d13053b855)
resource "stackit_logs_access_token" "retail_app_ecs_eventbridge_ecs" {
  count        = var.eventbridge_ecs_count
  project_id   = var.project_id
  instance_id  = var.eventbridge_ecs_logs_instance_id
  display_name = "EventBridge-E-9339b05e-${count.index}"
  permissions  = ["write"]
}
