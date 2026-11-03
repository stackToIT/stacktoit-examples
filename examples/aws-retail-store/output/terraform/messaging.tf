# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.dependencies.aws_mq_broker.mq (../../lib/dependencies/mq.tf:12) — RECONFIGURE / MEDIUM
# NOT CARRIED (module.dependencies.aws_mq_broker.mq): user — the broker users are not copied: the draft writes one stackit_rabbitmq_credential for the instance, a user whose username and password STACKIT generates (both computed, pinned provider) — clients get new credentials.
# NOT CARRIED (module.dependencies.aws_mq_broker.mq): apply_immediately = true — when a change reaches the broker is not carried: Amazon MQ applies a change in the next maintenance window unless apply_immediately applies it at once … — this configuration cannot choose between the two; the documentation read does not say when STACKIT applies a change to an instance or whether it restarts the broker, so agree the change window with the operator before the cutover. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.dependencies.aws_mq_broker.mq): auto_minor_version_upgrade = true — the minor-version upgrade policy is not carried: Amazon MQ upgrades the broker to new minor versions as it releases them when auto_minor_version_upgrade is true … — the draft pins the version its variable names and nothing in this configuration upgrades it later; whether STACKIT patches an instance on its own is not stated in the documentation read, so keeping the instance current is a task the operator plans. (shortened: the whole reason is in the trace of this block)
# DEFAULT plan_name: var.mq_plan_name defaults to stackit-rabbitmq-8.16.50-replica … A proposal the customer confirms or changes; it does not close the sizing decision.
# The decision DEC-GEN-CONVERT-SIZE-FROM-SOURCE (alias `convert:module.dependencies.aws_mq_broker.mq:mq_plan_name:SIZE_FROM_SOURCE`) stays open: check it, and answer choose-the-size in decisions.yaml if the plan is wrong; the next run then writes no default.
# WARNING mq-rabbitmq-major-version: The broker runs RabbitMQ 3.x and STACKIT RabbitMQ is 4.x: classic queue mirroring (the ha-mode policies) was removed in 4.0, so a mirrored classic queue becomes a quorum queue.
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING engine-version-upgrade: Engine version UPGRADE: the source runs RabbitMQ 3.13 (engine_version); STACKIT RabbitMQ in eu01 offers 4.1 (service catalogue of eu01, read 2026-10-18), none of them the source's version.
# DEFAULT: reachable on STACKIT from the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients of this service, and from no other address; change the list with var.mq_allowed_cidrs or answer the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.aws_mq_broker.mq:exposure:EXPOSURE_WIDENED`) in decisions.yaml — check that these are all its clients.
# The clients are module.retail_app_ecs.module.orders_service.aws_ecs_service.this, the members of module.retail_app_ecs.module.orders_service.aws_security_group.this (named by module.dependencies.aws_security_group_rule.mq[0]), the only clients the source admitted; the egress addresses are those of every pod of stackit_ske_cluster.retail_app_ecs_cluster, so the list is wider than the source's by the other workloads of the cluster — check that is acceptable; the rule names its group through a module input or a list the scan does not pin to one element, so check that no client is missing.
# stackit_rabbitmq_instance has no network attribute (pinned provider; parameters.sgw_acl is its only access control), so any placement in a drafted network is not carried; the RabbitMQ instance is on its own endpoint outside the project network …
# SECURITY_OBSERVATION Single-node data store of module.dependencies.aws_mq_broker.mq, deployment_mode (non-blocking): The source broker module.dependencies.aws_mq_broker.mq runs as SINGLE_INSTANCE: one broker in one availability zone, no standby. Source: ../../lib/dependencies/mq.tf:12. In the draft (NOT_VERIFIED): the redundancy of the drafted stackit_rabbitmq_instance is the plan the draft leaves to a person (a variable), and this build does not compare it with the source's single instance.
#   Hardening, if wanted (a note, not a change; owner Security Architect): choose a target plan with more than one node, or accept the single instance knowingly.
# trace: TR-6212f52df434 (engineering/trace/messaging.md#TR-6212f52df434)
resource "stackit_rabbitmq_instance" "dependencies_mq" {
  project_id = var.project_id
  name       = "retail-store-ecs-orders-broker"
  plan_name  = var.mq_plan_name
  version    = var.mq_version
  parameters = {
    sgw_acl = join(",", coalescelist(var.mq_allowed_cidrs, stackit_ske_cluster.retail_app_ecs_cluster.egress_address_ranges))
  }
}

# from module.dependencies.aws_mq_broker.mq.
# the credential of the clients of stackit_rabbitmq_instance.dependencies_mq: the instance has no host, port, user or password attribute (pinned provider).
# host, hosts, port, username, password, uri, uris, management, http_api_uri and http_api_uris are computed attributes of this credential (password and uri are sensitive); the provider schema describes none of them.
# A RabbitMQ credential is a user of the whole instance: the broker users of the source (and their tags and permissions) are not copied, and the vhosts, queues and exchanges of the broker are created in the instance outside Terraform.
# STACKIT generates the password; the sensitive output dependencies_mq_rabbitmq_credential_password exposes it (a reference to this resource, never a value).
# Read it after the apply and give it to every client before the cutover; the state holds it in plain text and the draft creates no secret for it.
# trace: TR-9aa24821e695 (engineering/trace/messaging.md#TR-9aa24821e695)
resource "stackit_rabbitmq_credential" "dependencies_mq" {
  project_id  = var.project_id
  instance_id = stackit_rabbitmq_instance.dependencies_mq.instance_id
}

# from module.dependencies.aws_mq_broker.mq.
output "dependencies_mq_rabbitmq_credential_password" {
  description = "The password STACKIT generated for the credential stackit_rabbitmq_credential.dependencies_mq of module.dependencies.aws_mq_broker.mq. Sensitive: tofu output hides it from the plan, the state holds it in plain text."
  value       = stackit_rabbitmq_credential.dependencies_mq.password
  sensitive   = true
}

# from module.dependencies.aws_mq_broker.mq.
output "dependencies_mq_rabbitmq_credential_host" {
  description = "The host of the instance's endpoint (host of the credential stackit_rabbitmq_credential.dependencies_mq of module.dependencies.aws_mq_broker.mq); a move step reads it with tofu output -raw."
  value       = stackit_rabbitmq_credential.dependencies_mq.host
}

# from module.dependencies.aws_mq_broker.mq.
output "dependencies_mq_rabbitmq_credential_port" {
  description = "The port of the instance's endpoint (port of the credential stackit_rabbitmq_credential.dependencies_mq of module.dependencies.aws_mq_broker.mq); a move step reads it with tofu output -raw."
  value       = stackit_rabbitmq_credential.dependencies_mq.port
}

# from module.dependencies.aws_mq_broker.mq.
output "dependencies_mq_rabbitmq_credential_management" {
  description = "The management URL of the instance (management of the credential stackit_rabbitmq_credential.dependencies_mq of module.dependencies.aws_mq_broker.mq); a move step reads it with tofu output -raw. Sensitive: the provider does not say whether it embeds a credential, so tofu output hides it from the plan."
  value       = stackit_rabbitmq_credential.dependencies_mq.management
  sensitive   = true
}
