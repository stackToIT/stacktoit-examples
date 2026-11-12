# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.dependencies.module.catalog_rds.aws_rds_cluster.this (.terraform/modules/dependencies.catalog_rds/main.tf:61) — REPLATFORM / LOW
# STACKIT has no MySQL; test the application against MariaDB before cutover.
# DEFAULT: var.catalog_rds_version is 10.11, the only MariaDB version the eu01 catalogue of 2026-10-18 lists: StackToIT chose it because no other is offered, not because the source states it (the source runs aurora-mysql, an engine change to MariaDB, so no version of the source is carried over). Confirm that the application runs on MariaDB 10.11 and read the catalogue again before the apply; when STACKIT offers a second version the variable has no default.
# REVIEW: the source is not proven publicly accessible, so the connectivity of the STACKIT instance is a decision: stackit_mariadb_instance has no private-network option in the pinned provider … — an accepted change in exposure, not a preserved property. (full text: engineering/trace/data.md)
# DEFAULT: reachable on STACKIT from the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients of this service, and from no other address; the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.catalog_rds.aws_rds_cluster.this:exposure:EXPOSURE_WIDENED`) in decisions.yaml holds this block; change the list with var.catalog_rds_allowed_cidrs — check that these are all its clients.
# The clients are module.retail_app_ecs.module.catalog_service.aws_ecs_service.this, the members of module.retail_app_ecs.module.catalog_service.aws_security_group.this (named by module.dependencies.module.catalog_rds.aws_security_group_rule.default_ingress[0]), the only clients the source admitted; the egress addresses are those of every pod of stackit_ske_cluster.retail_app_ecs_cluster … — check that is acceptable; the rule names its group through a module input or a list the scan does not pin to one element, so check that no client is missing. (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_security_group_rule.default_ingress): source_security_group_id — the members of a security group the scan cannot name reach the source listener (port 3306) through this rule … the DEFAULT of var.catalog_rds_allowed_cidrs carries them as the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods). (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): db_subnet_group_name — stackit_mariadb_instance has no subnet, availability-zone or IP-family attribute (pinned provider): clients reach the instance at the endpoint STACKIT assigns.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): port = 3306 — stackit_mariadb_instance has no port setting (pinned provider): clients use the port of the STACKIT endpoint.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): master_username = root — stackit_mariadb_credential takes no username: the username and the password are computed by STACKIT (pinned provider) — clients get new credentials.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): master_password — the source password is not copied: stackit_mariadb_credential has no password input, STACKIT generates it (the password is computed and sensitive, pinned provider) — hand the new one to the application.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): database_name = catalog — stackit_mariadb_instance has no database attribute (pinned provider): create the database after connecting.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): preferred_maintenance_window = sun:05:00-sun:06:00, allow_major_version_upgrade = true, db_cluster_parameter_group_name — stackit_mariadb_instance has no maintenance window, version-upgrade policy, extended-support, CA-certificate … (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): backup_retention_period = 7, preferred_backup_window = 02:00-03:00 — stackit_mariadb_instance has no backup setting (pinned provider).
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster.this): skip_final_snapshot = true — stackit_mariadb_instance has no final-snapshot or delete-time backup-retention setting (pinned provider): the instance is deleted immediately … — export the data first if it must survive the cut-over. (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster_instance.this): identifier = (reads a variable; its default is not printed), db_subnet_group_name, preferred_maintenance_window = sun:05:00-sun:06:00, db_parameter_group_name — cluster members are not separate STACKIT resources — the plan (plan_name) defines the nodes (pinned provider): member names, failover priority, zone, subnet, windows, upgrade policy, parameter group, CA certificate and instance profile have no attribute.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_rds_cluster_instance.this): monitoring_role_arn — Enhanced Monitoring, Performance Insights and Database Insights have no stackit_mariadb_instance attribute (pinned provider) — decide how the database is monitored.
# module.dependencies.module.catalog_rds.aws_appautoscaling_policy.this: switched off in the source (count = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_rds.aws_appautoscaling_target.this: switched off in the source (count = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_rds.aws_rds_cluster_endpoint.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_rds.aws_rds_cluster_role_association.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# WARNING aurora-storage-encrypted-mariadb: Storage is encrypted at rest with an AWS-managed key.
# WARNING aurora-mysql-mariadb-auth: The source engine is MySQL 8 and its accounts do not move.
# WARNING aurora-mysql-mariadb-json: MariaDB stores JSON as text, not in a binary format as MySQL: its JSON data type is an alias for LONGTEXT, so the JSON columns of the source become text columns and JSON values are compared as strings, where MySQL compares them as JSON values.
# WARNING aurora-mysql-mariadb-collation: The defaults of the character set and the collation differ: MySQL 8.0 uses utf8mb4 and utf8mb4_0900_ai_ci, MariaDB 10.11 uses latin1 or utf8 and latin1_swedish_ci or utf8_general_ci, and MariaDB names utf8mb4_uca1400_ai_ci as the counterpart default only from 11.4.
# WARNING aurora-mysql-mariadb-sql-mode: The default sql_mode differs: MySQL 8.0 sets ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES, NO_ZERO_IN_DATE, NO_ZERO_DATE, ERROR_FOR_DIVISION_BY_ZERO and NO_ENGINE_SUBSTITUTION; MariaDB 10.11 sets STRICT_TRANS_TABLES, ERROR_FOR_DIVISION_BY_ZERO, NO_AUTO_CREATE_USER and NO_ENGINE_SUBSTITUTION.
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# recovery window: the source restores to any point within 7 days (Aurora uploads log records to S3 continuously; docs.aws.amazon.com, Restoring a DB cluster to a specified time).
# STACKIT MariaDB takes a backup every 4 hours and holds it 14 days (a specific backup restores to the instance; the instance has no setting for either, docs.stackit.cloud, MariaDB: Backup and restore, last updated Mar 27, 2026).
# The page documents no point-in-time restore, so no point between two backups is shown to be restorable and the window is not shown to be equal: check a restore at the latest point the application needs before relying on it.
# LEDGER backup retention: 7 days → service-managed backups, retention not set in this draft — REVIEW
# Lifecycle of module.dependencies.module.catalog_rds.aws_rds_cluster.this not written to this block: ignore_changes = [replication_source_identifier … (full text: engineering/trace/data.md)
# SECURITY_OBSERVATION Final snapshot skipped of module.dependencies.module.catalog_rds.aws_rds_cluster.this, skip_final_snapshot (non-blocking): The source aws_rds_cluster module.dependencies.module.catalog_rds.aws_rds_cluster.this is deleted without a final snapshot (skip_final_snapshot = true): when it is destroyed, its data is gone unless it was exported or backed up separately. Source: .terraform/modules/dependencies.catalog_rds/main.tf:61.
#   … Hardening, if wanted (a note, not a change; owner Security Architect): export the data (or take a backup you keep) before the instance is destroyed, and do not rely on the draft's destroy to keep it. (full text: engineering/trace/data.md)
# SECURITY_OBSERVATION Single-node data store of module.dependencies.module.catalog_rds.aws_rds_cluster.this, aws_rds_cluster_instance (non-blocking): The source cluster module.dependencies.module.catalog_rds.aws_rds_cluster.this has one instance (module.dependencies.module.catalog_rds.aws_rds_cluster_instance.this): no reader in a second zone to take over, a failure or a maintenance of that instance interrupts the database. Source: .terraform/modules/dependencies.catalog_rds/main.tf:175.
#   In the draft (NOT_VERIFIED): the redundancy of the drafted stackit_mariadb_instance is its flavor and plan, which the draft states where it can (see the ledger row high availability when the source states standby); this build does not compare it with the source's single instance. Hardening, if wanted (a note, not a change; owner Security Architect): choose a target flavor with a replica, or accept the single instance knowingly.
# name made unique within the draft from the source address: module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this would also be named retail-store-ecs-catalog. STACKIT refuses a data service whose name another data service of the project has … (full text: engineering/trace/data.md)
# trace: TR-c392beafd341 (engineering/trace/data.md#TR-c392beafd341)
resource "stackit_mariadb_instance" "dependencies_catalog_rds_this" {
  project_id = var.project_id
  name       = "retail-store-ecs-catalog-dependencies-catalog-rds-this"
  version    = var.catalog_rds_version
  plan_name  = var.catalog_rds_plan_name
  parameters = {
    sgw_acl = join(",", coalescelist(var.catalog_rds_allowed_cidrs, stackit_ske_cluster.retail_app_ecs_cluster.egress_address_ranges))
  }
}

# from module.dependencies.module.catalog_rds.aws_rds_cluster.this.
# the credential's username and password are computed by STACKIT (pinned provider); the source master username is not set.
# DEFAULT: STACKIT generates the password of this user (stackit_mariadb_credential.password is computed and sensitive, pinned provider; no STACKIT user takes a password) and the sensitive output dependencies_catalog_rds_this_admin_password exposes it; the source password and its Secrets Manager management are not copied. Read it after the apply and give it to every client before the cutover (the state holds it in plain text); storing it in STACKIT Secrets Manager is the alternative of the record admin-password, the draft creates no secret.
# trace: TR-2fa350496480 (engineering/trace/data.md#TR-2fa350496480)
resource "stackit_mariadb_credential" "dependencies_catalog_rds_this" {
  project_id  = var.project_id
  instance_id = stackit_mariadb_instance.dependencies_catalog_rds_this.instance_id
}

# from module.dependencies.module.catalog_rds.aws_rds_cluster.this.
output "dependencies_catalog_rds_this_admin_password" {
  description = "The password STACKIT generated for the credential created by stackit_mariadb_credential for module.dependencies.module.catalog_rds.aws_rds_cluster.this (the username is computed too). Sensitive: tofu output hides it from the plan, the state holds it in plain text."
  value       = stackit_mariadb_credential.dependencies_catalog_rds_this.password
  sensitive   = true
}

# from module.dependencies.module.orders_rds.aws_rds_cluster.this (.terraform/modules/dependencies.orders_rds/main.tf:61) — REPLATFORM / MEDIUM
# flavor_id 2.4 = 2 vCPU / 4 GiB, single-node (eu01 catalogue 2026-10-18).
# NOT CARRIED (module.dependencies.module.orders_rds.aws_security_group_rule.default_ingress): source_security_group_id — the members of a security group the scan cannot name reach the source listener (port 5432) through this rule … the DEFAULT of var.orders_rds_allowed_cidrs carries them as the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods). (full text: engineering/trace/data.md)
# REVIEW: the source is not proven publicly accessible, so the connectivity of the STACKIT instance is a decision: its endpoint is public and limited by the list you give — an accepted change in exposure, not a preserved property.
# DEFAULT: reachable on STACKIT from the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients of this service, and from no other address; the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.orders_rds.aws_rds_cluster.this:exposure:EXPOSURE_WIDENED`) in decisions.yaml holds this block; change the list with var.orders_rds_allowed_cidrs — check that these are all its clients.
# The clients are module.retail_app_ecs.module.orders_service.aws_ecs_service.this, the members of module.retail_app_ecs.module.orders_service.aws_security_group.this (named by module.dependencies.module.orders_rds.aws_security_group_rule.default_ingress[0]), the only clients the source admitted; the egress addresses are those of every pod of stackit_ske_cluster.retail_app_ecs_cluster … — check that is acceptable; the rule names its group through a module input or a list the scan does not pin to one element, so check that no client is missing. (full text: engineering/trace/data.md)
# PITR on PostgreSQL Flex restores into a new cloned instance; backups are kept 32–90 days.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster.this): db_subnet_group_name — stackit_postgresflex_instance has no subnet, availability-zone or IP-family attribute (pinned provider): clients reach the instance at the endpoint STACKIT assigns.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster.this): port = 5432 — stackit_postgresflex_instance has no port setting (pinned provider): clients use the port of the STACKIT endpoint.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster.this): master_password — the source password is not copied: stackit_postgresflex_user has no password input, STACKIT generates it (the password is computed and sensitive, pinned provider) — hand the new one to the application.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster.this): preferred_maintenance_window = sun:05:00-sun:06:00, allow_major_version_upgrade = false, db_cluster_parameter_group_name — stackit_postgresflex_instance has no maintenance window, version-upgrade policy, extended-support, CA-certificate … (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster.this): skip_final_snapshot = true — stackit_postgresflex_instance has no final-snapshot or delete-time backup-retention setting (pinned provider): the instance is deleted immediately … — export the data first if it must survive the cut-over. (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster_instance.this): identifier = (reads a variable; its default is not printed), db_subnet_group_name, preferred_maintenance_window = sun:05:00-sun:06:00, db_parameter_group_name — cluster members are not separate STACKIT resources — the flavor (flavor_id: single or replica) defines the nodes (pinned provider): member names, failover priority, zone, subnet, windows, upgrade policy, parameter group, CA certificate and instance profile have no attribute.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_rds_cluster_instance.this): monitoring_role_arn — Enhanced Monitoring, Performance Insights and Database Insights have no stackit_postgresflex_instance attribute (pinned provider) — decide how the database is monitored.
# module.dependencies.module.orders_rds.aws_appautoscaling_policy.this: switched off in the source (count = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.orders_rds.aws_appautoscaling_target.this: switched off in the source (count = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.orders_rds.aws_rds_cluster_endpoint.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.orders_rds.aws_rds_cluster_role_association.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# DEFAULT: flavor_id = 2.4, the flavor derived from the source (module.dependencies.module.orders_rds.aws_rds_cluster.this (source class db.t3.medium) has 2 vCPU and 4 GiB (AWS price list); 2.4 is the smallest single-node PostgreSQL Flex flavor of the eu01 catalogue (2026-10-18) that covers it: 2 vCPU / 4 GiB). … (full text: engineering/trace/data.md)
# The decision DEC-GEN-CONVERT-SIZE-FROM-SOURCE (alias `convert:module.dependencies.module.orders_rds.aws_rds_cluster.this:orders_rds_flavor_id:SIZE_FROM_SOURCE`) stays open: check it, and answer choose-the-size in decisions.yaml if the flavor is wrong; the next run then writes flavor_id as var.orders_rds_flavor_id without a default.
# WARNING aurora-storage-encrypted: Storage is encrypted at rest with an AWS-managed key; the PostgreSQL Flex encryption block covers customer keys only (the pinned STACKIT provider) and STACKIT does not state the default without it: no STACKIT fact is documented, so at-rest encryption is not established until the PostgreSQL Flex product pages or a test on a STACKIT project state it.
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# recovery window: the source restores to any point within 7 days (Aurora uploads log records to S3 continuously; docs.aws.amazon.com, Restoring a DB cluster to a specified time).
# NOTE: 2 more notes are in the trace.
# The pages and the API state no granularity and not how close to the present the last restorable point is (the API says it is calculated between the first and the last backup), so the window is not shown to be equal: check a restore at the latest point the application needs before relying on it.
# LEDGER backup retention: 7 days → retention_days = 32 — TRANSFORMED
# SECURITY_OBSERVATION Final snapshot skipped of module.dependencies.module.orders_rds.aws_rds_cluster.this, skip_final_snapshot (non-blocking): The source aws_rds_cluster module.dependencies.module.orders_rds.aws_rds_cluster.this is deleted without a final snapshot (skip_final_snapshot = true): when it is destroyed, its data is gone unless it was exported or backed up separately. Source: .terraform/modules/dependencies.orders_rds/main.tf:61.
#   … Hardening, if wanted (a note, not a change; owner Security Architect): export the data (or take a backup you keep) before the instance is destroyed, and do not rely on the draft's destroy to keep it. (full text: engineering/trace/data.md)
# SECURITY_OBSERVATION Single-node data store of module.dependencies.module.orders_rds.aws_rds_cluster.this, aws_rds_cluster_instance (non-blocking): The source cluster module.dependencies.module.orders_rds.aws_rds_cluster.this has one instance (module.dependencies.module.orders_rds.aws_rds_cluster_instance.this): no reader in a second zone to take over, a failure or a maintenance of that instance interrupts the database. Source: .terraform/modules/dependencies.orders_rds/main.tf:175.
#   In the draft (NOT_VERIFIED): the redundancy of the drafted stackit_postgresflex_instance is its flavor and plan, which the draft states where it can (see the ledger row high availability when the source states standby); this build does not compare it with the source's single instance. Hardening, if wanted (a note, not a change; owner Security Architect): choose a target flavor with a replica, or accept the single instance knowingly.
# trace: TR-8ede34dda579 (engineering/trace/data.md#TR-8ede34dda579)
resource "stackit_postgresflex_instance" "dependencies_orders_rds_this" {
  project_id = var.project_id
  name       = "retail-store-ecs-orders"
  version    = "15"
  flavor_id  = "2.4"
  storage = {
    class = var.postgresflex_storage_class
    size  = var.orders_rds_storage_size
  }
  backup_schedule = "0 2 * * *"
  network = {
    acl          = coalescelist(var.orders_rds_allowed_cidrs, stackit_ske_cluster.retail_app_ecs_cluster.egress_address_ranges)
    access_scope = var.orders_rds_access_scope == "SNA" ? "SNA" : null
  }
  retention_days = 32
}

# from module.dependencies.module.orders_rds.aws_rds_cluster.this.
# DEFAULT: STACKIT generates the password of this user (stackit_postgresflex_user.password is computed and sensitive, pinned provider; no STACKIT user takes a password) and the sensitive output dependencies_orders_rds_this_admin_password exposes it; the source password and its Secrets Manager management are not copied. Read it after the apply and give it to every client before the cutover (the state holds it in plain text); storing it in STACKIT Secrets Manager is the alternative of the record admin-password, the draft creates no secret.
# roles: var.orders_rds_admin_roles (default ["login"], the least privilege) — the RDS master user is a privileged role; no PostgreSQL Flex role is documented as its equivalent, so decide createdb / createrole.
# trace: TR-e7d38d4bcda5 (engineering/trace/data.md#TR-e7d38d4bcda5)
resource "stackit_postgresflex_user" "dependencies_orders_rds_this" {
  project_id  = var.project_id
  instance_id = stackit_postgresflex_instance.dependencies_orders_rds_this.instance_id
  username    = "root"
  roles       = var.orders_rds_admin_roles
}

# from module.dependencies.module.orders_rds.aws_rds_cluster.this.
output "dependencies_orders_rds_this_admin_password" {
  description = "The password STACKIT generated for the master user created by stackit_postgresflex_user for module.dependencies.module.orders_rds.aws_rds_cluster.this. Sensitive: tofu output hides it from the plan, the state holds it in plain text."
  value       = stackit_postgresflex_user.dependencies_orders_rds_this.password
  sensitive   = true
}

# from module.dependencies.module.orders_rds.aws_rds_cluster.this.
# owner: the generated master user — the source states no database owner; check that the application expects this one.
# the owner is a user with the login role only: STACKIT accepted that at create (observed on a STACKIT project on 2026-10-15), but its API does not show a database's owner (the database list returns options: null, reading one database is a 404), so whether the owner is applied in the database is inferred by StackToIT, not observed — check it after apply.
# trace: TR-7bc47518665f (engineering/trace/data.md#TR-7bc47518665f)
resource "stackit_postgresflex_database" "dependencies_orders_rds_this_orders" {
  project_id  = var.project_id
  instance_id = stackit_postgresflex_instance.dependencies_orders_rds_this.instance_id
  name        = "orders"
  owner       = stackit_postgresflex_user.dependencies_orders_rds_this.username
}

# from module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (.terraform/modules/dependencies.checkout_elasticache_redis/main.tf:115) — RECONFIGURE / MEDIUM
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): subnet_group_name, security_group_ids — stackit_valkey_instance has no subnet, security-group, zone or IP-family attribute (pinned provider) … — list the clients. (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): port = 6379 — the port is the one stackit_valkey_credential returns (port is computed, pinned provider); clients switch to it.
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): maintenance_window = wed:03:00-wed:04:00, notification_topic_arn = "", data_tiering_enabled = false — stackit_valkey_instance has no maintenance window, minor-upgrade switch, notification topic … (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): snapshot_window = 06:30-07:30 — the snapshot time is not carried: stackit_valkey_instance takes parameters.snapshot (pinned provider), not generated — decide it.
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): snapshot_arns — the instance is created empty: seeding it from an ElastiCache snapshot is not generated — migrate the data (e.g. RDB export and import, or replication).
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): num_cache_clusters = 1 — the plan (plan_name) defines the nodes and replicas of a STACKIT Valkey instance (pinned provider).
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default): parameter_group_name — the parameter group is not translated: stackit_valkey_instance takes selected settings under parameters … — map the ones the application needs. (full text: engineering/trace/data.md)
# DEFAULT plan_name: var.elasticache_redis_plan_name defaults to stackit-keyvalue-1.4.10-single … A proposal the customer confirms or changes; it does not close the sizing decision. (full text: engineering/trace/data.md)
# The decision DEC-GEN-CONVERT-SIZE-FROM-SOURCE (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:elasticache_redis_plan_name:SIZE_FROM_SOURCE`) stays open: check it, and answer choose-the-size in decisions.yaml if the plan is wrong; the next run then writes no default.
# TODO: parameters.sgw_acl is set from var.elasticache_redis_allowed_cidrs, which has no default: without a list STACKIT applies its default ACL, every STACKIT customer's addresses. List the clients' CIDRs before planning.
# WARNING redis-transit-encryption-off: The source cache runs without TLS (transit_encryption_enabled = false).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING engine-version-upgrade: Engine version UPGRADE: the source runs Redis OSS 4.0.10 (engine_version); STACKIT Valkey in eu01 offers 8 (service catalogue of eu01), none of them the source's version.
# REVIEW: reachable on STACKIT from the addresses of var.elasticache_redis_allowed_cidrs instead of only from the private subnets (module.vpc.module.vpc.aws_subnet.private) — an accepted change in exposure, not a preserved property: decide it with the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:exposure:EXPOSURE_WIDENED`).
# stackit_valkey_instance has no network attribute (pinned provider; parameters.sgw_acl is its only access control), so any placement in a drafted network is not carried; the Valkey instance is on its own endpoint outside the project network … (full text: engineering/trace/data.md)
# REVIEW: The draft writes no default list of the clients' addresses: the rule module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group_rule.keyed["in#in#sg#0"] is no plain allow of a complete list of clients. Name the networks the clients connect from.
# DEFAULT: the draft carries out accept-the-public-endpoint for this Valkey instance: the endpoint is public, and only the CIDRs of var.elasticache_redis_allowed_cidrs may connect - list the networks of the clients, the variable has no default and is required.
# The decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:exposure:EXPOSURE_WIDENED`) stays open and holds this block: accept it in decisions.yaml, or answer redesign-the-endpoint if the clients must not reach the instance from outside; the next run then writes no default.
# SECURITY_OBSERVATION Transit encryption off of module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default … Source: .terraform/modules/dependencies.checkout_elasticache_redis/main.tf:115. In the draft (NOT_CARRIED): the draft does not carry the plaintext transport: STACKIT Key Value Store enforces TLS (a test on a STACKIT project, Valkey 8, eu01, 2026-09-24, found a plaintext connection closed by the server; knowledge base rule aws.elasticache_replication_group), so the clients that connect without TLS must switch to rediss://.
#   … (full text: engineering/trace/data.md)
# SECURITY_OBSERVATION Single-node data store of module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default, num_cache_clusters (non-blocking): The source replication group module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default runs on one node (num_cache_clusters states it): a failure or a maintenance of that node takes the cache down. Source: .terraform/modules/dependencies.checkout_elasticache_redis/main.tf:115.
#   In the draft (NOT_VERIFIED): the redundancy of the drafted stackit_valkey_instance is the plan the draft leaves to a person (a variable), and this build does not compare it with the source's single node. Hardening, if wanted (a note, not a change; owner Security Architect): choose a target plan with more than one node, or accept the single node knowingly.
# trace: TR-31aa12c1dfa8 (engineering/trace/data.md#TR-31aa12c1dfa8)
resource "stackit_valkey_instance" "dependencies_checkout_elasticache_redis_default" {
  project_id = var.project_id
  name       = "retail-store-ecs-checkout"
  plan_name  = var.elasticache_redis_plan_name
  version    = var.elasticache_redis_version
  parameters = {
    sgw_acl = join(",", var.elasticache_redis_allowed_cidrs)
  }
}

# from module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default.
# the credential of the clients of stackit_valkey_instance.dependencies_checkout_elasticache_redis_default: the instance has no host, port, user or password attribute (pinned provider).
# host, hosts, load_balanced_host, port, username, password and uri are computed attributes of this credential; the provider schema gives host and load_balanced_host no description, so read both.
# A service key authenticates fully against the instance; a test on a STACKIT project on 2026-09-24 found it denied CONFIG … The AUTH token, the users and the ACL of the source are not copied: limits a client relied on move to parameters.sgw_acl or to separate instances. (full text: engineering/trace/data.md)
# STACKIT generates the password; the sensitive output dependencies_checkout_elasticache_redis_default_valkey_credential_password exposes it (a reference to this resource, never a value).
# Read it after the apply and give it to every client before the cutover; the state holds it in plain text and the draft creates no secret for it.
# trace: TR-6a8844a36ea2 (engineering/trace/data.md#TR-6a8844a36ea2)
resource "stackit_valkey_credential" "dependencies_checkout_elasticache_redis_default" {
  project_id  = var.project_id
  instance_id = stackit_valkey_instance.dependencies_checkout_elasticache_redis_default.instance_id
}

# from module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default.
output "dependencies_checkout_elasticache_redis_default_valkey_credential_password" {
  description = "The password STACKIT generated for the credential stackit_valkey_credential.dependencies_checkout_elasticache_redis_default of module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default. Sensitive: tofu output hides it from the plan, the state holds it in plain text."
  value       = stackit_valkey_credential.dependencies_checkout_elasticache_redis_default.password
  sensitive   = true
}

# from module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this (.terraform/modules/dependencies.catalog_opensearch/main.tf:29) — REPLATFORM / LOW
# NOT CARRIED (module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this): cluster_config — the plan (plan_name) sets the size of a stackit_opensearch_instance (pinned provider): the cluster's instance types and counts, dedicated masters and zone awareness are not carried — choose the plan for them.
# NOT CARRIED (module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this): advanced_options, advanced_security_options, domain_endpoint_options, ebs_options, encrypt_at_rest, engine_version = OpenSearch_3.3, node_to_node_encryption, vpc_options — a stackit_opensearch_instance takes a plan, a version and parameters … — a person maps each one to the plan and the parameters. (full text: engineering/trace/data.md)
# NOT CARRIED (module.dependencies.module.catalog_opensearch.aws_opensearch_domain_policy.this): access_policies — the access policy of the domain: Statement[0] allows any principal es:* (with a condition or a part that is not visible statically): a stackit_opensearch_instance grants access by generated credentials (stackit_opensearch_credential) and the network ranges of parameters.sgw_acl (pinned provider) and has no resource policy … — list the principals and decide how their separation is kept (one instance per trust level, or in the application). (full text: engineering/trace/data.md)
# module.dependencies.module.catalog_opensearch.aws_opensearch_domain_saml_options.this: switched off in the source (count = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_opensearch.aws_opensearch_outbound_connection.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_opensearch.aws_opensearch_package_association.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# module.dependencies.module.catalog_opensearch.aws_opensearch_vpc_endpoint.this: switched off in the source (for_each = 0); nothing of it is migrated unless it is switched on
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# CRITICAL engine-version-downgrade: Engine version DOWNGRADE: the source runs OpenSearch 3.3 (engine_version); STACKIT OpenSearch in eu01 offers 2 (service catalogue of eu01), older than the source.
# DEFAULT: reachable on STACKIT from the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients of this service, and from no other address; the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this:exposure:EXPOSURE_WIDENED`) in decisions.yaml holds this block; change the list with var.catalog_opensearch_allowed_cidrs — check that these are all its clients.
# The clients are module.retail_app_ecs.module.catalog_service.aws_ecs_service.this, the members of module.retail_app_ecs.module.catalog_service.aws_security_group.this (named by module.dependencies.aws_security_group_rule.allow_https_from_client), the only clients the source admitted; the egress addresses are those of every pod of stackit_ske_cluster.retail_app_ecs_cluster … — check that is acceptable; the rule names its group through a module input or a list the scan does not pin to one element, so check that no client is missing. (full text: engineering/trace/data.md)
# stackit_opensearch_instance has no network attribute (pinned provider; parameters.sgw_acl is its only access control), so any placement in a drafted network is not carried; the OpenSearch instance is on its own endpoint outside the project network … (full text: engineering/trace/data.md)
# SECURITY_OBSERVATION Single-node data store of module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this, cluster_config.instance_count (non-blocking): The source domain module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this runs on one data node (cluster_config.instance_count = 1): a failure or a maintenance of that node takes the domain down. Source: .terraform/modules/dependencies.catalog_opensearch/main.tf:29.
#   In the draft (NOT_VERIFIED): the cluster_config is not carried (the drafted stackit_opensearch_instance takes a plan that sets the size, a variable); this build does not compare the plan with the source's single node. Hardening, if wanted (a note, not a change; owner Security Architect): choose a target plan with more than one node, or accept the single node knowingly.
# SECURITY_OBSERVATION Access policy for every principal of module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this … (full text: engineering/trace/data.md)
# name made unique within the draft from the source address: module.dependencies.module.catalog_rds.aws_rds_cluster.this would also be named retail-store-ecs-catalog. STACKIT refuses a data service whose name another data service of the project has … (full text: engineering/trace/data.md)
# trace: TR-5efbbe752c59 (engineering/trace/data.md#TR-5efbbe752c59)
resource "stackit_opensearch_instance" "dependencies_catalog_opensearch_this" {
  project_id = var.project_id
  name       = "retail-store-ecs-catalog-dependencies-catalog-opensearch-this"
  plan_name  = var.catalog_opensearch_plan_name
  version    = var.catalog_opensearch_version
  parameters = {
    sgw_acl = join(",", coalescelist(var.catalog_opensearch_allowed_cidrs, stackit_ske_cluster.retail_app_ecs_cluster.egress_address_ranges))
  }
}

# from module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this.
# the credential of the clients of stackit_opensearch_instance.dependencies_catalog_opensearch_this: the instance has no host, port, user or password attribute (pinned provider).
# host, hosts, port, scheme, username, password and uri are computed attributes of this credential (password and uri are sensitive); the provider schema gives host and hosts no description, so read both.
# STACKIT OpenSearch issues credentials with full access and has no per-principal or per-index permission: the access policy, the fine-grained users and the roles of the source are not copied; who may connect is the network list parameters.sgw_acl and whoever holds this credential.
# STACKIT generates the password; the sensitive output dependencies_catalog_opensearch_this_opensearch_credential_password exposes it (a reference to this resource, never a value).
# Read it after the apply and give it to every client before the cutover; the state holds it in plain text and the draft creates no secret for it.
# trace: TR-71c158d59d3e (engineering/trace/data.md#TR-71c158d59d3e)
resource "stackit_opensearch_credential" "dependencies_catalog_opensearch_this" {
  project_id  = var.project_id
  instance_id = stackit_opensearch_instance.dependencies_catalog_opensearch_this.instance_id
}

# from module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this.
output "dependencies_catalog_opensearch_this_opensearch_credential_password" {
  description = "The password STACKIT generated for the credential stackit_opensearch_credential.dependencies_catalog_opensearch_this of module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. Sensitive: tofu output hides it from the plan, the state holds it in plain text."
  value       = stackit_opensearch_credential.dependencies_catalog_opensearch_this.password
  sensitive   = true
}

# ALTERNATIVE, NOT AN EQUIVALENT: DynamoDB (1 table(s)) → one MongoDB Flex instance, each table a collection — rule aws.dynamodb_table/dynamodb · REDESIGN / MEDIUM · KB 0.428.0 · review required.
# The data access layer is rewritten against the MongoDB API; move the data with an export (DynamoDB export to S3 → mongoimport) — nothing replicates it.
# replicas = 3 / Replica: DynamoDB replicates every table across several availability zones of its region; a 3-member replica set keeps redundancy within the STACKIT region.
# backup_schedule is a default (02:00 daily): DynamoDB on-demand backups and AWS Backup plans do not map one to one.
# NOT CARRIED: capacity modes (provisioned/on-demand, auto scaling — size the flavor instead), DynamoDB Streams (use change streams or an outbox), transaction semantics (TransactWriteItems limits; MongoDB multi-document transactions behave differently), conditional-write expressions, PartiQL … (full text: engineering/trace/data.md)
# TABLE module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this (.terraform/modules/dependencies.dynamodb_carts/main.tf:1) → collection "retail-store-ecs-carts": key id → _id (or a unique index on id); GSI idx_global_customerId {customerId: 1} → secondary index (strongly consistent in MongoDB; the projection is not needed); GSI projections and capacities → NOT CARRIED (a MongoDB index finds whole documents; capacity is flavor sizing); billing mode PAY_PER_REQUEST → NOT CARRIED (flavor sizing).
# module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# replaces: module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this
# trace: TR-a2c77bb1d7ef (engineering/trace/data.md#TR-a2c77bb1d7ef)
resource "stackit_mongodbflex_instance" "dynamodb_tables" {
  project_id = var.project_id
  name       = "dynamodb-tables"
  acl        = var.dynamodb_tables_allowed_cidrs
  version    = var.dynamodb_tables_version
  flavor = {
    cpu = var.dynamodb_tables_cpu
    ram = var.dynamodb_tables_ram
  }
  replicas = 3
  storage = {
    class = var.mongodbflex_storage_class
    size  = var.dynamodb_tables_storage_gb
  }
  backup_schedule = "0 2 * * *"
  options = {
    type                       = "Replica"
    point_in_time_window_hours = var.dynamodb_tables_pitr_hours
  }
}
