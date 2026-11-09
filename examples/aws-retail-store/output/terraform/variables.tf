# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Values StackToIT cannot know. Variables without a default must be set before plan.

variable "alb_cluster_network_id" {
  type        = string
  description = "The id of the network SKE created for stackit_ske_cluster.retail_app_ecs_cluster: the network named shoot--<hash>--<the name of the cluster> in the list of `stackit network list --project-id <project>`, there once the cluster exists (the provider does not export it). To apply only the cluster first, any text will do here."
  validation {
    condition     = can(regex("\\S", var.alb_cluster_network_id))
    error_message = "Must not be blank: give the id of the network of the cluster (stackit network list), or any text while only the cluster is applied first."
  }
}

variable "alb_health_ok_status" {
  type        = list(string)
  description = "HTTP status codes the health check of pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this accepts (module.retail_app_ecs.module.alb.aws_lb_target_group.main does not set a matcher or it is not visible statically; AWS applies its default)."
}

variable "alb_interval_jitter" {
  type        = string
  description = "Jitter added to the STACKIT ALB health-check interval, e.g. \"1s\". Required by stackit_application_load_balancer; the source load balancer has no such setting and STACKIT documents no default."
}

variable "alb_labels" {
  type        = map(string)
  description = "Labels of stackit_application_load_balancer.retail_app_ecs_alb_this, from the tags of module.retail_app_ecs.module.alb.aws_lb.this. The source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want."
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "alb_plan_id" {
  type        = string
  description = "STACKIT Application Load Balancer plan for module.retail_app_ecs.module.alb.aws_lb.this. Plans in eu01 (catalogue 2026-10-18): p10 (Application-Load-Balancer-Dedicated-10-EU01). Default: the only plan the catalogue lists."
  default     = "p10"
}

variable "alb_target_ips" {
  type        = list(string)
  description = "Private IPs of the nodes of the SKE cluster behind pool retail-app-ecs-alb-main of module.retail_app_ecs.module.alb.aws_lb.this: the NodePort Service ui-nodeport of the workload ui (ECS service module.retail_app_ecs.module.ui_service.aws_ecs_service.this) listens on node port 30000 of every node. STACKIT exports no node address to Terraform (stackit_ske_cluster) and the IPs change as the node pool scales and is updated: set them from the cluster, or answer the decision DEC-GEN-CONVERT-INGRESS-EXPOSURE-PATH (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:target_pools:INGRESS_EXPOSURE_PATH`) (aws.ingress.exposure-path) with another exposure path."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for SKE node pools and for servers spread like the source group. Unset (null), the draft takes its three zones (<region>-1, <region>-2, <region>-3) of var.region (local.availability_zones, the zones of the catalogue snapshots); a value here overrides it."
  default     = null
  validation {
    condition     = var.availability_zones != null || contains(["eu01", "eu02"], var.region)
    error_message = "The draft does not know the zones of this region: it derives them for eu01, eu02 only (the regions whose zones the STACKIT catalogue lists). Set availability_zones."
  }
}

variable "carts_service_task_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_carts_service_task_role replacing the AWS policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.carts_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "catalog_opensearch_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT OpenSearch instance for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.catalog_service.aws_security_group.this admit (module.retail_app_ecs.module.catalog_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.catalog_opensearch_allowed_cidrs == null ? false : alltrue([for c in var.catalog_opensearch_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "catalog_opensearch_plan_name" {
  type        = string
  description = "STACKIT opensearch plan for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this (source sizing unknown)."
}

variable "catalog_opensearch_version" {
  type        = string
  description = "STACKIT opensearch version for module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this. STACKIT OpenSearch in eu01 offers 2 (catalogue 2026-10-18); the source runs 3.3. The source is newer than every offered version, so there is no default (decision ENGINE_VERSION_DOWNGRADE): a snapshot of 3.3 cannot be restored into 2 (OpenSearch restores a snapshot into the same or a newer version only); reindex from the source, or write to both during the cutover (dual-write), is the path; whether the clients work against 2 is unknown."
}

variable "catalog_rds_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT MariaDB instance for module.dependencies.module.catalog_rds.aws_rds_cluster.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.catalog_service.aws_security_group.this admit (module.retail_app_ecs.module.catalog_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.catalog_rds_allowed_cidrs == null ? false : alltrue([for c in var.catalog_rds_allowed_cidrs : can(cidrnetmask(c))])
    error_message = "Every entry an IPv4 CIDR (a.b.c.d/n); IPv6 cannot be added. An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null is refused."
  }
}

variable "catalog_rds_plan_name" {
  type        = string
  description = "STACKIT MariaDB plan for module.dependencies.module.catalog_rds.aws_rds_cluster.this (source class db.t3.medium). eu01 catalogue 2026-10-18 — single-node: stackit-mariadb-1.4.10-single, stackit-mariadb-2.4.10-single, stackit-mariadb-2.8.50-single, stackit-mariadb-4.8.50-single; replica (HA): stackit-mariadb-1.2.10-replica, stackit-mariadb-1.4.10-replica, stackit-mariadb-1.4.50-replica, stackit-mariadb-16.32.100-replica, stackit-mariadb-16.32.1000-replica, stackit-mariadb-16.32.1000-replica-HiPerf, stackit-mariadb-16.32.250-replica, stackit-mariadb-16.32.500-replica, stackit-mariadb-16.64.1000-replica, stackit-mariadb-16.64.1000-replica-HiPerf, stackit-mariadb-16.64.500-replica, stackit-mariadb-2.4.10-replica, stackit-mariadb-2.4.50-replica, stackit-mariadb-2.8.10-replica, stackit-mariadb-2.8.100-replica, stackit-mariadb-2.8.250-replica, stackit-mariadb-2.8.50-replica, stackit-mariadb-4.16.100-replica, stackit-mariadb-4.16.250-replica, stackit-mariadb-4.16.50-replica, stackit-mariadb-4.16.500-replica, stackit-mariadb-4.16.500-replica-HiPerf, stackit-mariadb-4.8.10-replica, stackit-mariadb-4.8.100-replica, stackit-mariadb-4.8.250-replica, stackit-mariadb-4.8.250-replica-HiPerf, stackit-mariadb-4.8.50-replica, stackit-mariadb-8.16.100-replica, stackit-mariadb-8.16.250-replica, stackit-mariadb-8.16.50-replica, stackit-mariadb-8.16.500-replica, stackit-mariadb-8.16.500-replica-HiPerf, stackit-mariadb-8.32.100-replica, stackit-mariadb-8.32.1000-replica, stackit-mariadb-8.32.1000-replica-HiPerf, stackit-mariadb-8.32.250-replica, stackit-mariadb-8.32.500-replica. Not offered: stackit-mariadb-16.32.500-replica-hiperf (in the catalogue, not in STACKIT's service-plans table https://docs.stackit.cloud/products/databases/mariadb/reference/service-plans/; nodes and high availability not documented). The source is single-node: a single plan keeps it, a replica plan adds high availability."
}

variable "catalog_rds_version" {
  type        = string
  description = "STACKIT MariaDB version for module.dependencies.module.catalog_rds.aws_rds_cluster.this (source aurora-mysql 8.0). The default is 10.11, the only version STACKIT MariaDB offers (the eu01 catalogue of 2026-10-18)."
  default     = "10.11"
}

variable "catalog_service_task_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_catalog_service_task_role replacing the AWS policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.catalog_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "checkout_service_task_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_checkout_service_task_role replacing the AWS policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role (the source allows dynamodb:*, logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.checkout_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data)), module.dependencies.aws_iam_policy.carts_dynamo (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "cluster_api_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the Kubernetes API of the SKE cluster stackit_ske_cluster.retail_app_ecs_cluster that replaces module.retail_app_ecs.aws_ecs_cluster.cluster (extensions.acl). The API endpoint of an SKE cluster is public, so only the CIDRs listed here may connect to it: list the admin and CI networks that run kubectl and the deployment of the manifests. The draft creates this cluster, so no source list exists to carry; no default is given and none is invented: at least one CIDR is required."
  validation {
    condition     = length(var.cluster_api_allowed_cidrs) > 0 && alltrue([for c in var.cluster_api_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "At least one CIDR (address/prefix length); an empty list, an empty entry or null would leave the service on its wider default access list."
  }
}

variable "cluster_machine_type" {
  type        = string
  description = "STACKIT machine type replacing the node pool of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. See https://docs.stackit.cloud/products/compute-engine/server/basics/machine-types/"
}

variable "cluster_nodes_max" {
  type        = number
  description = "Maximum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster. The services of the cluster ask for 5 vCPU / 10 GiB at the ceilings (the cluster block lists them). An SKE node pool's maximum must be at least the number of its zones: 3 zones are selected by default (var.availability_zones)."
  validation {
    condition     = var.cluster_nodes_max >= (var.availability_zones == null ? 3 : length(var.availability_zones))
    error_message = "At least the number of zones in var.availability_zones: the SKE API refuses a node pool whose maximum node count is below the number of its zones (\"maximum node count should be greater than or equal to the number of zones specified for this pool\"). Set the maximum to at least that number, or list fewer zones."
  }
}

variable "cluster_nodes_min" {
  type        = number
  description = "Minimum nodes of the node pool replacing the capacity of the ECS cluster module.retail_app_ecs.aws_ecs_cluster.cluster (size it from the CPU and memory the services' manifests request). The services of the cluster ask for 5 vCPU / 10 GiB at the floors (the cluster block lists them)."
}

variable "default_ipv4_nameservers" {
  type        = list(string)
  description = "IPv4 nameservers of the networks whose source used the cloud's own resolver. Unset (null), the draft takes the addresses of STACKIT's own DNS Resolver (beta) of var.region (eu01, eu02 are the regions the page lists; https://docs.stackit.cloud/products/network/core-networking/dns-resolver/basics/concepts/), documented for workloads inside STACKIT; it resolves public names only. STACKIT sets 1.1.1.1, 8.8.8.8 and 9.9.9.9 in a public project when none are given (https://docs.stackit.cloud/products/network/core-networking/virtual-network/how-tos/create-and-manage-virtual-networks/), which this default replaces. In a Network Area (SNA) project use the area's default_nameservers. A value here overrides the addresses of the region; for a region the page lists none for, a value is required."
  default     = null
  validation {
    condition     = var.default_ipv4_nameservers != null || contains(["eu01", "eu02"], var.region)
    error_message = "The DNS Resolver page documents addresses for eu01, eu02 only. Set default_ipv4_nameservers for this region."
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
  description = "Point-in-time recovery window in hours for the instance replacing the DynamoDB tables (DynamoDB point-in-time recovery restores to any second within 1 to 35 days). STACKIT documents this window of MongoDB Flex as fixed at 30 hours (docs.stackit.cloud, MongoDB Flex: Backup, restore and clone), so 30 is the value to set; it is the documented figure, not one derived from the source's backup retention. The provider states no maximum for the attribute, and whether the API refuses another value is not established."
  default     = 30
}

variable "dynamodb_tables_ram" {
  type        = number
  description = "RAM of the MongoDB Flex instance replacing the DynamoDB tables (size from the working set; the unit is not stated by the API: GB or GiB). MongoDB Flex flavors in eu01 (catalogue 2026-10-18, vCPU/RAM, unit of the RAM not stated): 1/2, 1/4, 1/8, 2/4, 2/8, 2/16, 4/8, 4/16, 4/32, 8/16, 8/32, 8/64, 16/32, 16/64."
}

variable "dynamodb_tables_storage_gb" {
  type        = number
  description = "Storage in GB of the MongoDB Flex instance (sum of the tables' current sizes plus index overhead and growth). Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of \"Gigabytes\" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: at least 10 GB (tested on a STACKIT project on 2026-11-03)."
  validation {
    condition     = var.dynamodb_tables_storage_gb >= 10
    error_message = "Must be at least 10."
  }
}

variable "dynamodb_tables_version" {
  type        = string
  description = "MongoDB Flex version for the instance replacing the DynamoDB tables. DynamoDB has no MongoDB version: the data access layer is rewritten against the MongoDB API. Default: the newest version MongoDB Flex offers in eu01 (catalogue 2026-10-18: 8.0, 7.0)."
  default     = "8.0"
}

variable "elasticache_redis_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT valkey instance for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (parameters.sgw_acl). The list replaces STACKIT's default ACL (the STACKIT public or internal IP ranges, which admit every STACKIT customer's addresses): the source's own network boundary (security groups, VPC, access policies) is not carried over, so list the clients. No default. The draft writes no default list of the clients' addresses: the rule module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group_rule.keyed[\"in#in#sg#0\"] is no plain allow of a complete list of clients. Name the networks the clients connect from. The draft carries out the option accept-the-public-endpoint of the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default:exposure:EXPOSURE_WIDENED`) by default: the Valkey endpoint is public and only the CIDRs listed here may connect to it. No default is given and none is invented (neither STACKIT's documented service ranges nor any other range is a fallback): at least one CIDR is required. The step waits for the decision: accept this option or choose otherwise (a redesign of the endpoint (Valkey has no private-network option in the pinned provider)) in decisions.yaml."
  validation {
    condition     = length(var.elasticache_redis_allowed_cidrs) > 0 && alltrue([for c in var.elasticache_redis_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "At least one CIDR (address/prefix length); an empty list, an empty entry or null would leave the service on its wider default access list."
  }
}

variable "elasticache_redis_plan_name" {
  type        = string
  description = "STACKIT valkey plan for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (source cache.t3.micro). DEFAULT stackit-keyvalue-1.4.10-single, derived from the source (node type cache.t3.micro has 2 vCPU and 0.5 GiB (AWS price list), and the source is a single node): the smallest single-node Key Value Store plan of the eu01 catalogue (2026-10-18) that holds 0.5 GiB (0.5369 GB at 10^9 bytes per GB) of memory (the plan table gives its RAM as \"GB\" and does not say whether a GB is 10^9 or 2^30 bytes, so the plan is chosen to hold the source's memory when a GB is 10^9 bytes, which it then also does when a GB is 2^30 bytes (it is never smaller than the source whichever way the table is read)): 1 vCPU / 4 GB RAM / 10 GB disk per node; the disk is not a figure of the source, so the smallest disk of that size is taken and the disk is open. It is a default, not a decision: confirm or change it; the price on the cost page moves with it (docs.stackit.cloud, Key Value Store, Reference, Service plans, RAM (GB) per node, read 2026-11-02)."
  default     = "stackit-keyvalue-1.4.10-single"
}

variable "elasticache_redis_version" {
  type        = string
  description = "STACKIT valkey version for module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default. STACKIT Valkey in eu01 offers 8 (catalogue 2026-10-18); the source runs Redis OSS 4.0.10. The source is older: moving it upgrades the engine, and the version is your choice (no default)."
}

variable "eventbridge_ecs_count" {
  type        = number
  description = "Number of instances of what the source switches by its count `(var.container_insights_setting == \"enhanced\" && var.lifecycle_events_enabled) ? 1 : 0`, first module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs: the draft takes no value of the condition."
}

variable "eventbridge_ecs_logs_instance_id" {
  type        = string
  description = "ID of the STACKIT Logs instance (stackit_logs_instance.<label>.instance_id) that the producers of the log policy module.retail_app_ecs.aws_cloudwatch_log_resource_policy.eventbridge_ecs write to."
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

variable "logs_acl_retention_180d" {
  type        = list(string)
  description = "CIDRs allowed to reach the Logs instance stackit_logs_instance.logs_retention_180d (acl), which replaces module.retail_app_ecs.aws_cloudwatch_log_group.ecs_tasks. The source authorises its log ingest by identity and states no allowed ranges, and what an instance with no entry allows, every address or none, is stated by no source read: list the clients' CIDRs. No default; an empty list is refused."
  validation {
    condition     = length(var.logs_acl_retention_180d) > 0 && alltrue([for c in var.logs_acl_retention_180d : can(cidrhost(c, 0))])
    error_message = "At least one CIDR (address/prefix length); an empty list, an empty entry or null would leave the resource on a default access list no source states."
  }
}

variable "mongodbflex_storage_class" {
  type        = string
  description = "MongoDB Flex storage performance class."
}

variable "mq_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT RabbitMQ instance for module.dependencies.aws_mq_broker.mq. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.orders_service.aws_security_group.this admit (module.retail_app_ecs.module.orders_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.mq_allowed_cidrs == null ? false : alltrue([for c in var.mq_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "mq_plan_name" {
  type        = string
  description = "STACKIT RabbitMQ plan for module.dependencies.aws_mq_broker.mq (source mq.m5.large). DEFAULT stackit-rabbitmq-8.16.50-replica, derived from the source (broker instance type mq.m5.large has 2 vCPU and 8 GiB (AWS price list), and the broker is a single instance): the smallest replica (three nodes, high availability) RabbitMQ plan of the eu01 catalogue (2026-10-18) that holds 2 vCPU and 8 GiB (8.59 GB at 10^9 bytes per GB) of memory (the plan table gives its RAM as \"GB\" and does not say whether a GB is 10^9 or 2^30 bytes, so the plan is chosen to hold the source's memory when a GB is 10^9 bytes, which it then also does when a GB is 2^30 bytes (it is never smaller than the source whichever way the table is read)): 8 vCPU / 16 GB RAM / 50 GB disk per node; the disk is not a figure of the source, so the smallest disk of that size is taken and the disk is open; no single-node plan of that size exists, so this replica plan adds the replicas the source does not have, and their price; this plan is larger than the one the other reading gives: reading the table's GB as a GiB, stackit-rabbitmq-4.8.50-single (4 vCPU / 8 GB RAM / 50 GB disk per node) would hold the source, and the draft is priced on the larger plan; if the table's GB is a GiB, answer choose-the-size and set stackit-rabbitmq-4.8.50-single. It is a default, not a decision: confirm or change it; the price on the cost page moves with it (docs.stackit.cloud, RabbitMQ, Reference, RabbitMQ service plans, vCPU and RAM per node, read 2026-11-02)."
  default     = "stackit-rabbitmq-8.16.50-replica"
}

variable "mq_version" {
  type        = string
  description = "STACKIT RabbitMQ version for module.dependencies.aws_mq_broker.mq. STACKIT RabbitMQ in eu01 offers 4.1 (catalogue 2026-10-18); the source runs 3.13. The source is older: moving it upgrades the engine, and the version is your choice (no default)."
}

variable "orders_rds_access_scope" {
  type        = string
  description = "Network access scope of the PostgreSQL Flex instance for module.dependencies.module.orders_rds.aws_rds_cluster.this: PUBLIC (a public instance endpoint limited by var.orders_rds_allowed_cidrs) or SNA (reachable over the STACKIT network area only; private preview, enabled accounts only, pinned provider). The source is private or not proven publicly accessible, so its exposure changes: choosing PUBLIC is an accepted change, not a preserved property, and there is no fallback from SNA to PUBLIC. Default: PUBLIC, the option accept-the-public-endpoint of the decision DEC-GEN-CONVERT-EXPOSURE-WIDENED (alias `convert:module.dependencies.module.orders_rds.aws_rds_cluster.this:exposure:EXPOSURE_WIDENED`), which stays open: check it, or choose SNA."
  default     = "PUBLIC"
  validation {
    condition     = contains(["PUBLIC", "SNA"], var.orders_rds_access_scope)
    error_message = "Must be one of PUBLIC, SNA."
  }
}

variable "orders_rds_admin_roles" {
  type        = list(string)
  description = "Roles of the PostgreSQL Flex master user generated for module.dependencies.module.orders_rds.aws_rds_cluster.this. Documented roles: login (log in and connect), createdb (create databases), createrole (create and manage other roles) — https://docs.stackit.cloud/products/databases/postgresql-flex/how-tos/create-and-manage-users-for-postgresql-flex/. The default is the least privilege that logs in and owns the initial database; no PostgreSQL Flex role is documented as the equivalent of the RDS master user's privileges, so add createdb / createrole if the application needs them."
  default     = ["login"]
}

variable "orders_rds_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the STACKIT PostgreSQL Flex instance for module.dependencies.module.orders_rds.aws_rds_cluster.this. Default: the empty list, which the draft replaces by the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods), the clients the source's security group(s) module.retail_app_ecs.module.orders_service.aws_security_group.this admit (module.retail_app_ecs.module.orders_service.aws_ecs_service.this). A list you give replaces it: name every client that connects from another address. The addresses are known after apply, so the instance is created after the cluster. STACKIT's own default access list (the addresses of every STACKIT customer) is not used."
  default     = []
  validation {
    condition     = var.orders_rds_allowed_cidrs == null ? false : alltrue([for c in var.orders_rds_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "Every entry a CIDR (address/prefix length). An empty list stands for the egress addresses of stackit_ske_cluster.retail_app_ecs_cluster (its pods); null and an empty entry are refused."
  }
}

variable "orders_rds_storage_size" {
  type        = number
  description = "PostgreSQL Flex storage size in GB for module.dependencies.module.orders_rds.aws_rds_cluster.this: the source states no allocated_storage (Aurora storage grows automatically) — set the size STACKIT should provision. Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of \"Gigabytes\" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: 5 to 4000 GB, the range of the flavor 2.4 (eu01 catalogue 2026-10-18)."
  validation {
    condition     = var.orders_rds_storage_size >= 5 && var.orders_rds_storage_size <= 4000
    error_message = "Must be at least 5 and at most 4000."
  }
}

variable "orders_service_task_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_orders_service_task_role replacing the AWS policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.orders_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

variable "postgresflex_storage_class" {
  type        = string
  description = "PostgreSQL Flex storage performance class."
}

variable "private_count" {
  type        = number
  description = "Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.private (its count/for_each is not known statically)."
}

variable "private_ipv4_prefixes" {
  type        = list(string)
  description = "IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.private, one per instance (their number is var.private_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets."
  validation {
    condition     = try(alltrue([for rs in [[for c in var.private_ipv4_prefixes : { start = sum([for i, o in split(".", cidrhost(c, 0)) : tonumber(o) * pow(256, 3 - i)]), size = pow(2, 32 - tonumber(split("/", c)[1])) }]] : alltrue([for i, p in rs : alltrue([for j, q in rs : i >= j || p.start + p.size <= q.start || q.start + q.size <= p.start])])]), false)
    error_message = "Valid IPv4 CIDRs (a.b.c.d/n) that do not overlap each other: they replace subnets of one source VPC, which do not overlap."
  }
}

variable "project_id" {
  type        = string
  description = "STACKIT project ID the migrated resources are created in."
}

variable "public_count" {
  type        = number
  description = "Number of stackit_network instances replacing module.vpc.module.vpc.aws_subnet.public (its count/for_each is not known statically)."
}

variable "public_ipv4_prefixes" {
  type        = list(string)
  description = "IPv4 prefixes (CIDR) for the networks replacing module.vpc.module.vpc.aws_subnet.public, one per instance (their number is var.public_count); reuse the source CIDRs unless the address plan changes. The source CIDR of at least one of them is not visible statically (the count.index or each.key of its instance is not known, a data source, read when a plan runs), so the draft carries no default for it: enter the prefix each network gets."
  validation {
    condition     = try(alltrue([for rs in [[for c in var.public_ipv4_prefixes : { start = sum([for i, o in split(".", cidrhost(c, 0)) : tonumber(o) * pow(256, 3 - i)]), size = pow(2, 32 - tonumber(split("/", c)[1])) }]] : alltrue([for i, p in rs : alltrue([for j, q in rs : i >= j || p.start + p.size <= q.start || q.start + q.size <= p.start])])]), false)
    error_message = "Valid IPv4 CIDRs (a.b.c.d/n) that do not overlap each other: they replace subnets of one source VPC, which do not overlap."
  }
}

variable "region" {
  type        = string
  description = "STACKIT region."
  default     = "eu01"
}

variable "sg_alb_labels" {
  type        = map(string)
  description = "the labels of stackit_security_group.retail_app_ecs_alb_this, from the tags of module.retail_app_ecs.module.alb.aws_security_group.this: the source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want"
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "sg_alb_sg_labels" {
  type        = map(string)
  description = "the labels of stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix, from the tags of module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix: the source reads a variable for its tags (or its provider's default_tags), so the values here are the scan's reading of the variable's default, not proven: set the labels you want"
  default = {
    Name = "retail-store-ecs-ui"
  }
}

variable "sg_carts_service_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.carts_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_carts_service_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_carts_service_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_catalog_service_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.catalog_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_catalog_service_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_catalog_service_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_checkout_service_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.checkout_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_checkout_service_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_checkout_service_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_orders_service_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.orders_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_orders_service_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_orders_service_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "sg_ui_service_name" {
  type        = string
  description = "the name of module.retail_app_ecs.module.ui_service.aws_security_group.this comes from a root variable that a tfvars or -var can override: its default is not a fact of the source (1 to 63 characters, alphanumeric runs joined by one separator)"
  validation {
    condition     = length(var.sg_ui_service_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$", var.sg_ui_service_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[A-Za-z0-9]+((-|_|\\s|\\.)[A-Za-z0-9]+)*$"
  }
}

variable "ui_service_task_project_roles" {
  type        = list(string)
  description = "STACKIT project roles for service account retail_app_ecs_ui_service_task_role replacing the AWS policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_role (the source allows logs:CreateLogGroup, logs:CreateLogStream, logs:DescribeLogGroups, logs:DescribeLogStreams, logs:PutLogEvents, ssmmessages:CreateControlChannel, ssmmessages:CreateDataChannel, ssmmessages:OpenControlChannel, ssmmessages:OpenDataChannel; policies not visible statically: module.retail_app_ecs.module.ui_service.aws_iam_policy.cloudwatch_logs (Statement[0].Resource is not known statically (runtime-data))). The provider documents how to list the available roles: stackit curl https://authorization.api.stackit.cloud/v2/{resourceType}/{resourceId}/roles. Set [] if the workload needs no STACKIT API access."
}

# local.availability_zones is var.availability_zones when it is set, else the zones of var.region (eu01, eu02 are the regions whose catalogue snapshot lists them): a change of var.region moves the zones with it.
# local.default_ipv4_nameservers is var.default_ipv4_nameservers when it is set, else the addresses of STACKIT's own DNS Resolver documented for var.region (eu01, eu02): a change of var.region moves it with it.
locals {
  availability_zones       = var.availability_zones != null ? var.availability_zones : ["${var.region}-1", "${var.region}-2", "${var.region}-3"]
  default_ipv4_nameservers = var.default_ipv4_nameservers != null ? var.default_ipv4_nameservers : lookup({ eu01 = ["192.214.161.53", "213.17.17.17", "188.34.111.111"], eu02 = ["45.137.172.101", "45.137.172.102", "45.137.172.103"] }, var.region)
}
