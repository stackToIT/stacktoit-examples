# Values of the variables of this draft (written by stacktoit). Remove the # of a line and give the value; run stacktoit again on the same output folder.
# The run takes a value the draft declares and whose type fits, writes it to terraform/target-values.auto.tfvars.json and frees the steps that waited for it. It tells you which values it refused and why.
# A value that exists only after a first apply (the network of a cluster, the addresses of its nodes) can be added later. A line left as it is stays an open variable; nothing here is a default.

# The id of the network SKE created for stackit_ske_cluster.retail_app_ecs_cluster: the network named shoot--<hash>--<the name of the cluster> in the list of `stackit network list --project-id <project>`, there once the cluster exists (the provider does not export it). To apply only the cluster first, any text will do here.
# alb_cluster_network_id =   # string

# HTTP status codes the health check of pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this accepts (module.retail_app_ecs.module.alb.aws_lb_target_group.main does not set a matcher or it is not visible statically; AWS applies its default).
# alb_health_ok_status =   # list of string

# Jitter added to the STACKIT ALB health-check interval, e.g. "1s". Required by stackit_application_load_balancer; the source load balancer has no such setting and STACKIT documents no default.
# alb_interval_jitter =   # string

# Private IPs of the nodes of the SKE cluster behind pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this: the NodePort Service ui-nodeport of the workload ui (ECS service module.retail_app_ecs.module.ui_service.aws_ecs_service.this) listens on node port 30000 of every node. STACKIT exports no node address to Terraform (stackit_ske_cluster) and the IPs change as the node pool scales and is updated: set them from the cluster, or answer the decision DEC-GEN-CONVERT-INGRESS-EXPOSURE-PATH (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:target_pools:INGRESS_EXPOSURE_PATH`) (aws.ingress.exposure-path) with another exposure path.
# alb_target_ips =   # list of string

# STACKIT project roles for service account retail_app_ecs_carts_service_task_role replacing the AWS policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.carts_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access.
# carts_service_task_project_roles =   # list of string

# STACKIT opensearch plan for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this (source sizing unknown).
# catalog_opensearch_plan_name =   # string

# STACKIT opensearch version for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. STACKIT OpenSearch in eu01 offers 2 (catalogue 2026-10-18); the source runs 3.3. The source is newer than every offered version, so there is no default (decision ENGINE_VERSION_DOWNGRADE): a snapshot of 3.3 cannot be restored into 2 (OpenSearch restores a snapshot into the same or a newer version only); reindex from the source, or write to both during the cutover (dual-write), is the path; whether the clients work against 2 is unknown.
# catalog_opensearch_version =   # string

# STACKIT MariaDB plan for module.dependencies.module.catalog_rds.aws_rds_cluster.this (source class db.t3.medium). eu01 catalogue 2026-10-18 — single-node: stackit-mariadb-1.4.10-single, stackit-mariadb-2.4.10-single, stackit-mariadb-2.8.50-single, stackit-mariadb-4.8.50-single; replica (HA): stackit-mariadb-1.2.10-replica, stackit-mariadb-1.4.10-replica, stackit-mariadb-1.4.50-replica, stackit-mariadb-16.32.100-replica, stackit-mariadb-16.32.1000-replica, stackit-mariadb-16.32.1000-replica-HiPerf, stackit-mariadb-16.32.250-replica, stackit-mariadb-16.32.500-replica, stackit-mariadb-16.64.1000-replica, stackit-mariadb-16.64.1000-replica-HiPerf, stackit-mariadb-16.64.500-replica, stackit-mariadb-2.4.10-replica, stackit-mariadb-2.4.50-replica, stackit-mariadb-2.8.10-replica, stackit-mariadb-2.8.100-replica, stackit-mariadb-2.8.250-replica, stackit-mariadb-2.8.50-replica, stackit-mariadb-4.16.100-replica, stackit-mariadb-4.16.250-replica, stackit-mariadb-4.16.50-replica, stackit-mariadb-4.16.500-replica, stackit-mariadb-4.16.500-replica-HiPerf, stackit-mariadb-4.8.10-replica, stackit-mariadb-4.8.100-replica, stackit-mariadb-4.8.250-replica, stackit-mariadb-4.8.250-replica-HiPerf, stackit-mariadb-4.8.50-replica, stackit-mariadb-8.16.100-replica, stackit-mariadb-8.16.250-replica, stackit-mariadb-8.16.50-replica, stackit-mariadb-8.16.500-replica, stackit-mariadb-8.16.500-replica-HiPerf, stackit-mariadb-8.32.100-replica, stackit-mariadb-8.32.1000-replica, stackit-mariadb-8.32.1000-replica-HiPerf, stackit-mariadb-8.32.250-replica, stackit-mariadb-8.32.500-replica. Not offered: stackit-mariadb-16.32.500-replica-hiperf (in the catalogue, not in STACKIT's service-plans table https://docs.stackit.cloud/products/databases/mariadb/reference/service-plans/; nodes and high availability not documented). The source is single-node: a single plan keeps it, a replica plan adds high availability.
# catalog_rds_plan_name =   # string

# STACKIT project roles for service account retail_app_ecs_catalog_service_task_role replacing the AWS policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.catalog_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access.
# catalog_service_task_project_roles =   # list of string

# STACKIT project roles for service account retail_app_ecs_checkout_service_task_role replacing the AWS policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.checkout_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access.
# checkout_service_task_project_roles =   # list of string

# CIDRs allowed to reach the Kubernetes API of the SKE cluster stackit_ske_cluster.retail_app_ecs_cluster that replaces module.retail_app_ecs.aws_ecs_cluster.cluster (extensions.acl). The API endpoint of an SKE cluster is public, so only the CIDRs listed here may connect to it: list the admin and CI networks that run kubectl and the deployment of the manifests. The draft creates this cluster, so no source list exists to carry; no default is given and none is invented: at least one CIDR is required.
# cluster_api_allowed_cidrs =   # list of string

# STACKIT machine type replacing the node pool of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. See https://docs.stackit.cloud/products/compute-engine/server/basics/machine-types/
# cluster_machine_type =   # string

# Maximum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. The services of the cluster ask for 5 vCPU / 10 GiB at the ceilings (the cluster block lists them). An SKE node pool's maximum must be at least the number of its zones: 3 zones are selected by default (var.availability_zones).
# cluster_nodes_max =   # number

# Minimum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster (size it from the CPU and memory the services' manifests request). The services of the cluster ask for 5 vCPU / 10 GiB at the floors (the cluster block lists them).
# cluster_nodes_min =   # number

# CIDRs allowed to reach the MongoDB Flex instance replacing the DynamoDB tables. DynamoDB had no network ACL (an IAM-authenticated regional endpoint); list the STACKIT network prefixes or egress addresses of the clients.
# dynamodb_tables_allowed_cidrs =   # list of string

# vCPUs of the MongoDB Flex instance replacing the DynamoDB tables (DynamoDB scales in capacity units; size from the observed load). MongoDB Flex flavors in eu01 (catalogue 2026-10-18, vCPU/RAM, unit of the RAM not stated): 1/2, 1/4, 1/8, 2/4, 2/8, 2/16, 4/8, 4/16, 4/32, 8/16, 8/32, 8/64, 16/32, 16/64.
# dynamodb_tables_cpu =   # number

# RAM of the MongoDB Flex instance replacing the DynamoDB tables (size from the working set; the unit is not stated by the API: GB or GiB). MongoDB Flex flavors in eu01 (catalogue 2026-10-18, vCPU/RAM, unit of the RAM not stated): 1/2, 1/4, 1/8, 2/4, 2/8, 2/16, 4/8, 4/16, 4/32, 8/16, 8/32, 8/64, 16/32, 16/64.
# dynamodb_tables_ram =   # number

# Storage in GB of the MongoDB Flex instance (sum of the tables' current sizes plus index overhead and growth). Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of "Gigabytes" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: at least 10 GB (tested on a STACKIT project on 2026-11-03).
# dynamodb_tables_storage_gb =   # number

# CIDRs allowed to reach the STACKIT valkey instance for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (parameters.sgw_acl). The list replaces STACKIT's default ACL (the STACKIT public or internal IP ranges, which admit every STACKIT customer's addresses): the source's own network boundary (security groups, VPC, access policies) is not carried over, so list the clients. No default. The draft writes no default list of the clients' addresses: the rule module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group_rule.keyed["in#in#sg#0"] is no plain allow of a complete list of clients. Name the networks the clients connect from. The draft carries out the option accept-the-public-endpoint of the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:exposure:EXPOSURE_WIDENED`) by default: the Valkey endpoint is public and only the CIDRs listed here may connect to it. No default is given and none is invented (neither STACKIT's documented service ranges nor any other range is a fallback): at least one CIDR is required. The step waits for the decision: accept this option or choose otherwise (a redesign of the endpoint (Valkey has no private-network option in the pinned provider)) in decisions.yaml.
# elasticache_redis_allowed_cidrs =   # list of string

# STACKIT valkey version for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default. STACKIT Valkey in eu01 offers 8 (catalogue 2026-10-18); the source runs Redis OSS 4.0.10. The source is older: moving it upgrades the engine, and the version is your choice (no default).
# elasticache_redis_version =   # string

# Number of instances of what the source switches by its count `(var.container_insights_setting == "enhanced" && var.lifecycle_events_enabled) ? 1 : 0`, first module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs: the draft takes no value of the condition.
# eventbridge_ecs_count =   # number

# ID of the STACKIT Logs instance (stackit_logs_instance.<label>.instance_id) that the producers of the log policy module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs write to.
# eventbridge_ecs_logs_instance_id =   # string

# Network access scope of the migrated STACKIT KMS keys and wrapping keys: PUBLIC (the key is reachable on the public STACKIT KMS endpoint) or SNA (reachable over the STACKIT network area only; pinned provider stackit_kms_key.access_scope; whether the account must be enabled for SNA was not checked). An AWS KMS key states no network of its own, so the exposure is not read from the source. Left unset, the STACKIT API applies PUBLIC, so the draft asks. No default: you decide.
# kms_access_scope =   # string

# STACKIT KMS key protection level (see the stackit_kms_key documentation).
# kms_protection =   # string

# CIDRs allowed to reach the Logs instance stackit_logs_instance.logs_retention_180d (acl), which replaces module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks. The source authorises its log ingest by identity and states no allowed ranges, and what an instance with no entry allows, every address or none, is stated by no source read: list the clients' CIDRs. No default; an empty list is refused.
# logs_acl_retention_180d =   # list of string

# MongoDB Flex storage performance class.
# mongodbflex_storage_class =   # string

# STACKIT RabbitMQ version for module.dependencies.aws_mq_broker.mq. STACKIT RabbitMQ in eu01 offers 4.1 (catalogue 2026-10-18); the source runs 3.13. The source is older: moving it upgrades the engine, and the version is your choice (no default).
# mq_version =   # string

# PostgreSQL Flex storage size in GB for module.dependencies.module.orders_rds.aws_rds_cluster.this: the source states no allocated_storage (Aurora storage grows automatically) — set the size STACKIT should provision. Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of "Gigabytes" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: 5 to 4000 GB, the range of the flavor 2.4 (eu01 catalogue 2026-10-18).
# orders_rds_storage_size =   # number

# STACKIT project roles for service account retail_app_ecs_orders_service_task_role replacing the AWS policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.orders_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access.
# orders_service_task_project_roles =   # list of string

# PostgreSQL Flex storage performance class.
# postgresflex_storage_class =   # string

# Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.private (its count/for_each is not known statically).
# private_count =   # number

# IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.private, one per instance (their number is var.private_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets.
# private_ipv4_prefixes =   # list of string

# STACKIT project ID the migrated resources are created in.
# project_id =   # string

# Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.public (its count/for_each is not known statically).
# public_count =   # number

# IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.public, one per instance (their number is var.public_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets.
# public_ipv4_prefixes =   # list of string

# the name of module.retail_app_ecs.module.carts_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)
# sg_carts_service_name =   # string

# the name of module.retail_app_ecs.module.catalog_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)
# sg_catalog_service_name =   # string

# the name of module.retail_app_ecs.module.checkout_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)
# sg_checkout_service_name =   # string

# the name of module.retail_app_ecs.module.orders_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)
# sg_orders_service_name =   # string

# the name of module.retail_app_ecs.module.ui_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)
# sg_ui_service_name =   # string

# STACKIT project roles for service account retail_app_ecs_ui_service_task_role replacing the AWS policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.ui_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access.
# ui_service_task_project_roles =   # list of string
