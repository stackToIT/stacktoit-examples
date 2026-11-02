# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Values StackToIT cannot know. Variables without a default must be set before plan.

variable "alb_interval_jitter" {
  type        = string
  description = "Jitter added to the STACKIT ALB health-check interval, e.g. \"1s\". Required by stackit_application_load_balancer; the source load balancer has no such setting and STACKIT documents no default."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for SKE node pools and for servers spread like the source group."
  default     = ["eu01-1", "eu01-2", "eu01-3"]
}

variable "default_ipv4_nameservers" {
  type        = list(string)
  description = "IPv4 nameservers of the networks whose source used the cloud's own resolver. Default: the addresses of STACKIT's own DNS Resolver (beta) in eu01 (https://docs.stackit.cloud/products/network/core-networking/dns-resolver/basics/concepts/), documented for workloads inside STACKIT; it resolves public names only. STACKIT sets 1.1.1.1, 8.8.8.8 and 9.9.9.9 in a public project when none are given (https://docs.stackit.cloud/products/network/core-networking/virtual-network/how-tos/create-and-manage-virtual-networks/), which this default replaces. In a Network Area (SNA) project use the area's default_nameservers."
  default     = ["192.214.161.53", "213.17.17.17", "188.34.111.111"]
}

variable "dependencies_catalog_opensearch_this_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT OpenSearch instance for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.catalog_service.aws_security_group.this admit (module.retail_app_ecs.module.catalog_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.dependencies_catalog_opensearch_this_allowed_cidrs == null ? false : alltrue([for c in var.dependencies_catalog_opensearch_this_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "dependencies_catalog_opensearch_this_plan_name" {
  type        = string
  description = "STACKIT opensearch plan for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this (source sizing unknown)."
}

variable "dependencies_catalog_opensearch_this_version" {
  type        = string
  description = "STACKIT opensearch version for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. STACKIT OpenSearch in eu01 offers 2 (catalogue 2026-10-18); the source runs 3.3. The source is newer than every offered version, so there is no default (decision ENGINE_VERSION_DOWNGRADE): a snapshot of 3.3 cannot be restored into 2 (OpenSearch restores a snapshot into the same or a newer version only); reindex from the source, or write to both during the cutover (dual-write), is the path; whether the clients work against 2 is unknown."
}

variable "dependencies_catalog_rds_this_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT MariaDB instance for module.dependencies.module.catalog_rds.aws_rds_cluster.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.catalog_service.aws_security_group.this admit (module.retail_app_ecs.module.catalog_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.dependencies_catalog_rds_this_allowed_cidrs == null ? false : alltrue([for c in var.dependencies_catalog_rds_this_allowed_cidrs : can(cidrnetmask(c))])
    error_message = "Every entry an IPv4 CIDR (a.b.c.d/n); IPv6 cannot be added. An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null is refused."
  }
}

variable "dependencies_catalog_rds_this_plan_name" {
  type        = string
  description = "STACKIT MariaDB plan for module.dependencies.module.catalog_rds.aws_rds_cluster.this (source class db.t3.medium). eu01 catalogue 2026-10-18 — single-node: stackit-mariadb-1.4.10-single, stackit-mariadb-2.4.10-single, stackit-mariadb-2.8.50-single, stackit-mariadb-4.8.50-single; replica (HA): stackit-mariadb-1.2.10-replica, stackit-mariadb-1.4.10-replica, stackit-mariadb-1.4.50-replica, stackit-mariadb-16.32.100-replica, stackit-mariadb-16.32.1000-replica, stackit-mariadb-16.32.1000-replica-HiPerf, stackit-mariadb-16.32.250-replica, stackit-mariadb-16.32.500-replica, stackit-mariadb-16.64.1000-replica, stackit-mariadb-16.64.1000-replica-HiPerf, stackit-mariadb-16.64.500-replica, stackit-mariadb-2.4.10-replica, stackit-mariadb-2.4.50-replica, stackit-mariadb-2.8.10-replica, stackit-mariadb-2.8.100-replica, stackit-mariadb-2.8.250-replica, stackit-mariadb-2.8.50-replica, stackit-mariadb-4.16.100-replica, stackit-mariadb-4.16.250-replica, stackit-mariadb-4.16.50-replica, stackit-mariadb-4.16.500-replica, stackit-mariadb-4.16.500-replica-HiPerf, stackit-mariadb-4.8.10-replica, stackit-mariadb-4.8.100-replica, stackit-mariadb-4.8.250-replica, stackit-mariadb-4.8.250-replica-HiPerf, stackit-mariadb-4.8.50-replica, stackit-mariadb-8.16.100-replica, stackit-mariadb-8.16.250-replica, stackit-mariadb-8.16.50-replica, stackit-mariadb-8.16.500-replica, stackit-mariadb-8.16.500-replica-HiPerf, stackit-mariadb-8.32.100-replica, stackit-mariadb-8.32.1000-replica, stackit-mariadb-8.32.1000-replica-HiPerf, stackit-mariadb-8.32.250-replica, stackit-mariadb-8.32.500-replica. Not offered: stackit-mariadb-16.32.500-replica-hiperf (in the catalogue, not in STACKIT's service-plans table https://docs.stackit.cloud/products/databases/mariadb/reference/service-plans/; nodes and high availability not documented). The source is single-node: a single plan keeps it, a replica plan adds high availability."
}

variable "dependencies_catalog_rds_this_version" {
  type        = string
  description = "STACKIT MariaDB version for module.dependencies.module.catalog_rds.aws_rds_cluster.this (source aurora-mysql 8.0). The default is 10.11, the only version STACKIT MariaDB offers (the eu01 catalogue of 2026-10-18)."
  default     = "10.11"
}

variable "dependencies_checkout_elasticache_redis_default_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT valkey instance for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (parameters.sgw_acl). The list replaces STACKIT's default ACL (the STACKIT public or internal IP ranges, which admit every STACKIT customer's addresses): the source's own network boundary (security groups, VPC, access policies) is not carried over, so list the clients. No default. The draft writes no default list of the clients' addresses: the rule module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group_rule.keyed[\"in#in#sg#0\"] is no plain allow of a complete list of clients. Name the networks the clients connect from. The draft carries out the option accept-the-public-endpoint of the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:exposure:EXPOSURE_WIDENED`) by default: the Valkey endpoint is public and only the CIDRs listed here may connect to it. No default is given and none is invented (neither STACKIT's documented service ranges nor any other range is a fallback): at least one CIDR is required. To choose otherwise (a redesign of the endpoint (Valkey has no private-network option in the pinned provider)), answer the decision in decisions.yaml."
  validation {
    condition     = length(var.dependencies_checkout_elasticache_redis_default_allowed_cidrs) > 0 && alltrue([for c in var.dependencies_checkout_elasticache_redis_default_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "At least one CIDR (address/prefix length); an empty list, an empty entry or null would leave the service on its wider default access list."
  }
}

variable "dependencies_checkout_elasticache_redis_default_plan_name" {
  type        = string
  description = "STACKIT valkey plan for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (source cache.t3.micro). DEFAULT stackit-keyvalue-1.4.10-single, derived from the source (node type cache.t3.micro has 2 vCPU and 0.5 GiB (AWS price list, cache_node_sizes.json), and the source is a single node): the smallest single-node Key Value Store plan of the eu01 catalogue (2026-10-18) that holds 0.5 GiB (0.5369 GB at 10^9 bytes per GB) of memory (the plan table gives its RAM as \"GB\" and does not say whether a GB is 10^9 or 2^30 bytes, so the plan is chosen to hold the source's memory when a GB is 10^9 bytes, which it then also does when a GB is 2^30 bytes (it is never smaller than the source whichever way the table is read)): 1 vCPU / 4 GB RAM / 10 GB disk per node; the disk is not a figure of the source, so the smallest disk of that size is taken and the disk is open. It is a proposal, not a decision: confirm or change it; the price on the cost page moves with it (docs.stackit.cloud, Key Value Store, Reference, Service plans, RAM (GB) per node, read 2026-11-02)."
  default     = "stackit-keyvalue-1.4.10-single"
}

variable "dependencies_checkout_elasticache_redis_default_version" {
  type        = string
  description = "STACKIT valkey version for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default. STACKIT Valkey in eu01 offers 8 (catalogue 2026-10-18); the source runs 4.0.10. The source is older: moving it upgrades the engine, and the version is your choice (no default)."
}

variable "dependencies_mq_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT RabbitMQ instance for module.dependencies.aws_mq_broker.mq. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.orders_service.aws_security_group.this admit (module.retail_app_ecs.module.orders_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.dependencies_mq_allowed_cidrs == null ? false : alltrue([for c in var.dependencies_mq_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "dependencies_mq_plan_name" {
  type        = string
  description = "STACKIT RabbitMQ plan for module.dependencies.aws_mq_broker.mq (source mq.m5.large). DEFAULT stackit-rabbitmq-8.16.50-replica, derived from the source (broker instance type mq.m5.large has 2 vCPU and 8 GiB (AWS price list, mq_broker_sizes.json), and the broker is a single instance): the smallest replica (three nodes, high availability) RabbitMQ plan of the eu01 catalogue (2026-10-18) that holds 2 vCPU and 8 GiB (8.59 GB at 10^9 bytes per GB) of memory (the plan table gives its RAM as \"GB\" and does not say whether a GB is 10^9 or 2^30 bytes, so the plan is chosen to hold the source's memory when a GB is 10^9 bytes, which it then also does when a GB is 2^30 bytes (it is never smaller than the source whichever way the table is read)): 8 vCPU / 16 GB RAM / 50 GB disk per node; the disk is not a figure of the source, so the smallest disk of that size is taken and the disk is open; no single-node plan of that size exists, so this replica plan adds the replicas the source does not have, and their price; this plan is larger than the one the other reading gives: reading the table's GB as a GiB, stackit-rabbitmq-4.8.50-single (4 vCPU / 8 GB RAM / 50 GB disk per node) would hold the source, and the draft is priced on the larger plan; if the table's GB is a GiB, answer choose-the-size and set stackit-rabbitmq-4.8.50-single. It is a proposal, not a decision: confirm or change it; the price on the cost page moves with it (docs.stackit.cloud, RabbitMQ, Reference, RabbitMQ service plans, vCPU and RAM per node, read 2026-11-02)."
  default     = "stackit-rabbitmq-8.16.50-replica"
}

variable "dependencies_mq_version" {
  type        = string
  description = "STACKIT RabbitMQ version for module.dependencies.aws_mq_broker.mq. STACKIT RabbitMQ in eu01 offers 4.1 (catalogue 2026-10-18); the source runs 3.13. The source is older: moving it upgrades the engine, and the version is your choice (no default)."
}

variable "dependencies_orders_rds_this_access_scope" {
  type        = string
  description = "Network access scope of the PostgreSQL Flex instance for module.dependencies.module.orders_rds.aws_rds_cluster.this: PUBLIC (a public instance endpoint limited by var.dependencies_orders_rds_this_allowed_cidrs) or SNA (reachable over the STACKIT network area only; private preview, enabled accounts only, pinned provider). The source is private or not proven publicly accessible, so its exposure changes: choosing PUBLIC is an accepted change, not a preserved property, and there is no fallback from SNA to PUBLIC. Default: PUBLIC, the option accept-the-public-endpoint of the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.orders_rds.aws_rds_cluster.this:exposure:EXPOSURE_WIDENED`), which stays open: check it, or choose SNA."
  default     = "PUBLIC"
  validation {
    condition     = contains(["PUBLIC", "SNA"], var.dependencies_orders_rds_this_access_scope)
    error_message = "Must be one of PUBLIC, SNA."
  }
}

variable "dependencies_orders_rds_this_admin_roles" {
  type        = list(string)
  description = "Roles of the PostgreSQL Flex master user generated for module.dependencies.module.orders_rds.aws_rds_cluster.this. Documented roles: login (log in and connect), createdb (create databases), createrole (create and manage other roles) — https://docs.stackit.cloud/products/databases/postgresql-flex/how-tos/create-and-manage-users-for-postgresql-flex/. The default is the least privilege that logs in and owns the initial database; no PostgreSQL Flex role is documented as the equivalent of the RDS master user's privileges, so add createdb / createrole if the application needs them."
  default     = ["login"]
}

variable "dependencies_orders_rds_this_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT PostgreSQL Flex instance for module.dependencies.module.orders_rds.aws_rds_cluster.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.orders_service.aws_security_group.this admit (module.retail_app_ecs.module.orders_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.dependencies_orders_rds_this_allowed_cidrs == null ? false : alltrue([for c in var.dependencies_orders_rds_this_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "dependencies_orders_rds_this_storage_size" {
  type        = number
  description = "PostgreSQL Flex storage size in GB for module.dependencies.module.orders_rds.aws_rds_cluster.this: the source states no allocated_storage (Aurora storage grows automatically) — set the size STACKIT should provision. Allowed: 5 to 4000 GB, the range of the flavor 2.4 (eu01 catalogue 2026-10-18)."
  validation {
    condition     = var.dependencies_orders_rds_this_storage_size >= 5 && var.dependencies_orders_rds_this_storage_size <= 4000
    error_message = "Must be at least 5 and at most 4000."
  }
}

variable "dynamodb_tables_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the MongoDB Flex instance replacing the DynamoDB tables. DynamoDB had no network ACL (an IAM-authenticated regional endpoint); list the STACKIT network prefixes or egress addresses of the clients."
}

variable "dynamodb_tables_cpu" {
  type        = number
  description = "vCPUs of the MongoDB Flex instance replacing the DynamoDB tables (DynamoDB scales in capacity units; size from the observed load). MongoDB Flex flavors in eu01 (catalogue 2026-10-18, vCPU/RAM, unit of the RAM not stated): 1/2, 1/4, 1/8, 2/4, 2/8, 2/16, 4/8, 4/16, 4/32, 8/16, 8/32, 8/64, 16/32, 16/64."
}

variable "dynamodb_tables_pitr_hours" {
  type        = number
  description = "Point-in-time recovery window in hours; check the maximum MongoDB Flex accepts (DynamoDB PITR restores to any second of up to 35 days)."
}

variable "dynamodb_tables_ram" {
  type        = number
  description = "RAM of the MongoDB Flex instance replacing the DynamoDB tables (size from the working set; the unit is not stated by the API: GB or GiB). MongoDB Flex flavors in eu01 (catalogue 2026-10-18, vCPU/RAM, unit of the RAM not stated): 1/2, 1/4, 1/8, 2/4, 2/8, 2/16, 4/8, 4/16, 4/32, 8/16, 8/32, 8/64, 16/32, 16/64."
}

variable "dynamodb_tables_storage_gb" {
  type        = number
  description = "Storage in GB of the MongoDB Flex instance (sum of the tables' current sizes plus index overhead and growth)."
}

variable "dynamodb_tables_version" {
  type        = string
  description = "MongoDB Flex version for the instance replacing the DynamoDB tables. DynamoDB has no MongoDB version: the data access layer is rewritten against the MongoDB API. Default: the newest version MongoDB Flex offers in eu01 (catalogue 2026-10-18: 8.0, 7.0)."
  default     = "8.0"
}

variable "kms_access_scope" {
  type        = string
  description = "Network access scope of the migrated STACKIT KMS keys and wrapping keys: PUBLIC (the key is reachable on the public STACKIT KMS endpoint) or SNA (reachable over the STACKIT network area only; pinned provider stackit_kms_key.access_scope; whether the account must be enabled for SNA was not checked). An AWS KMS key states no network of its own, so the exposure is not read from the source. Left unset, the STACKIT API applies PUBLIC, so the draft asks. No default: you decide."
  validation {
    condition     = contains(["PUBLIC", "SNA"], var.kms_access_scope)
    error_message = "Must be one of PUBLIC, SNA."
  }
}

variable "kms_protection" {
  type        = string
  description = "STACKIT KMS key protection level (see the stackit_kms_key documentation)."
}

variable "mongodbflex_storage_class" {
  type        = string
  description = "MongoDB Flex storage performance class."
}

variable "postgresflex_storage_class" {
  type        = string
  description = "PostgreSQL Flex storage performance class."
}

variable "project_id" {
  type        = string
  description = "STACKIT project ID the migrated resources are created in."
}

variable "region" {
  type        = string
  description = "STACKIT region."
  default     = "eu01"
}

variable "retail_app_ecs_alb_this_health_ok_status" {
  type        = list(string)
  description = "HTTP status codes the health check of pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this accepts (module.retail_app_ecs.module.alb.aws_lb_target_group.main does not set a matcher or it is not visible statically; AWS applies its default)."
}

variable "retail_app_ecs_alb_this_labels" {
  type        = map(string)
  description = "Labels of stackit_application_load_balancer.retail_app_ecs_alb_this, from the tags of module.retail_app_ecs.module.alb.aws_lb.this. The source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want."
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "retail_app_ecs_alb_this_network_id_target" {
  type        = number
  description = "Which instance of stackit_network.vpc_vpc_public the network_id of module.retail_app_ecs.module.alb.aws_lb.this means: the index of one candidate, stackit_network.vpc_vpc_public[0] to the last instance (the number of instances is not known statically). The source does not show it; no instance is assumed."
  validation {
    condition     = var.retail_app_ecs_alb_this_network_id_target >= 0
    error_message = "Must be at least 0."
  }
  validation {
    condition     = floor(var.retail_app_ecs_alb_this_network_id_target) == var.retail_app_ecs_alb_this_network_id_target
    error_message = "Must be a whole number (the index of one instance)."
  }
}

variable "retail_app_ecs_alb_this_plan_id" {
  type        = string
  description = "STACKIT Application Load Balancer plan for module.retail_app_ecs.module.alb.aws_lb.this. Plans in eu01 (catalogue 2026-10-18): p10 (Application-Load-Balancer-Dedicated-10-EU01). Default: the only plan the catalogue lists."
  default     = "p10"
}

variable "retail_app_ecs_alb_this_target_ips" {
  type        = list(string)
  description = "Private IPs of the nodes of the SKE cluster behind pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this: the NodePort Service ui-nodeport of the workload ui (ECS service module.retail_app_ecs.module.ui_service.aws_ecs_service.this) listens on node port 30000 of every node. STACKIT exports no node address to Terraform (stackit_ske_cluster) and the IPs change as the node pool scales and is updated: set them from the cluster, or answer the decision DEC-GEN-CONVERT-INGRESS-EXPOSURE-PATH (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:target_pools:INGRESS_EXPOSURE_PATH`) (aws.ingress.exposure-path) with another exposure path."
}

variable "retail_app_ecs_carts_service_task_execution_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_carts_service_task_execution_role replacing the AWS policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role (AWS managed/external policies arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_carts_service_task_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_carts_service_task_role replacing the AWS policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.carts_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_catalog_service_task_execution_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_catalog_service_task_execution_role replacing the AWS policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role (the source allows kms:Decrypt*, secretsmanager:GetSecretValue; AWS managed/external policies arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy; policies not visible statically: module.retail_app_ecs.aws_iam_policy.catalog_policy (module.retail_app_ecs.data.aws_iam_policy_document.catalog_db_secret names statement.resources reads [ aws_secretsmanager_secret.catalog_db.arn, aws_secretsmanager_secret.catalog_opensearch.arn, aws_kms_key.cmk.arn ], which is not known statically)). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_catalog_service_task_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_catalog_service_task_role replacing the AWS policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.catalog_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_checkout_service_task_execution_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_checkout_service_task_execution_role replacing the AWS policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role (AWS managed/external policies arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_checkout_service_task_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_checkout_service_task_role replacing the AWS policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.checkout_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_cluster_machine_type" {
  type        = string
  description = "STACKIT machine type replacing the node pool of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. See https://docs.stackit.cloud/products/compute-engine/server/basics/machine-types/"
}

variable "retail_app_ecs_cluster_nodes_max" {
  type        = number
  description = "Maximum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. The services of the cluster ask for 5 vCPU / 10 GiB at the ceilings (the cluster block lists them). An SKE node pool's maximum must be at least the number of its zones: 3 zones are selected by default (var.availability_zones)."
  validation {
    condition     = var.retail_app_ecs_cluster_nodes_max >= length(var.availability_zones)
    error_message = "At least the number of zones in var.availability_zones: the SKE API refuses a node pool whose maximum node count is below the number of its zones (\"maximum node count should be greater than or equal to the number of zones specified for this pool\"). Set the maximum to at least that number, or list fewer zones."
  }
}

variable "retail_app_ecs_cluster_nodes_min" {
  type        = number
  description = "Minimum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster (size it from the CPU and memory the services' manifests request). The services of the cluster ask for 5 vCPU / 10 GiB at the floors (the cluster block lists them)."
}

variable "retail_app_ecs_orders_service_task_execution_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_orders_service_task_execution_role replacing the AWS policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role (the source allows kms:Decrypt*, secretsmanager:GetSecretValue; AWS managed/external policies arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy; policies not visible statically: module.retail_app_ecs.aws_iam_policy.orders_policy (module.retail_app_ecs.data.aws_iam_policy_document.orders_db_secret names statement.resources reads [ aws_secretsmanager_secret.orders_db.arn, aws_secretsmanager_secret.mq.arn, aws_kms_key.cmk.arn ], which is not known statically)). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_orders_service_task_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_orders_service_task_role replacing the AWS policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.orders_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_ui_service_task_execution_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_ui_service_task_execution_role replacing the AWS policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role (AWS managed/external policies arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "retail_app_ecs_ui_service_task_role_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_ui_service_task_role replacing the AWS policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.ui_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "sg_retail_app_ecs_alb_sg_this_name_prefix_labels" {
  type        = map(string)
  description = "the labels of stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix, from the tags of module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix: the source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want"
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "sg_retail_app_ecs_alb_this_labels" {
  type        = map(string)
  description = "the labels of stackit_security_group.retail_app_ecs_alb_this, from the tags of module.retail_app_ecs.module.alb.aws_security_group.this: the source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want"
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "sg_retail_app_ecs_carts_service_this_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.carts_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_retail_app_ecs_carts_service_this_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_retail_app_ecs_carts_service_this_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_retail_app_ecs_catalog_service_this_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.catalog_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_retail_app_ecs_catalog_service_this_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_retail_app_ecs_catalog_service_this_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_retail_app_ecs_checkout_service_this_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.checkout_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_retail_app_ecs_checkout_service_this_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_retail_app_ecs_checkout_service_this_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_retail_app_ecs_orders_service_this_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.orders_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_retail_app_ecs_orders_service_this_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_retail_app_ecs_orders_service_this_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_retail_app_ecs_ui_service_this_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.ui_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_retail_app_ecs_ui_service_this_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_retail_app_ecs_ui_service_this_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "vpc_vpc_private_count" {
  type        = number
  description = "Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.private (its count/for_each is not known statically)."
}

variable "vpc_vpc_private_ipv4_prefixes" {
  type        = list(string)
  description = "IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.private, one per instance (their number is var.vpc_vpc_private_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets."
}

variable "vpc_vpc_public_count" {
  type        = number
  description = "Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.public (its count/for_each is not known statically)."
}

variable "vpc_vpc_public_ipv4_prefixes" {
  type        = list(string)
  description = "IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.public, one per instance (their number is var.vpc_vpc_public_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets."
}
