# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Values StackToIT cannot know. Variables without a default must be set before plan.

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for SKE node pools and for servers spread like the source group."
  default     = ["eu01-1", "eu01-2", "eu01-3"]
}

variable "containers_machine_type" {
  type        = string
  description = "STACKIT machine type of the node pool hosting the migrated container workloads (size from their CPU/memory requests). See https://docs.stackit.cloud/products/compute-engine/server/basics/machine-types/"
}

variable "containers_nodes_max" {
  type        = number
  description = "Maximum nodes of the node pool hosting the migrated container workloads."
  validation {
    condition     = var.containers_nodes_max >= length(var.availability_zones)
    error_message = "At least the number of zones in var.availability_zones: the SKE API refuses a node pool whose maximum node count is below the number of its zones (\"maximum node count should be greater than or equal to the number of zones specified for this pool\"). Set the maximum to at least that number, or list fewer zones."
  }
}

variable "containers_nodes_min" {
  type        = number
  description = "Minimum nodes of the node pool hosting the migrated container workloads."
}

variable "media_bucket_name" {
  type        = string
  description = "DNS-conform bucket name replacing google_storage_bucket.media."
  validation {
    condition     = length(var.media_bucket_name) <= 63
    error_message = "At most 63 characters."
  }
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.media_bucket_name))
    error_message = "The value must match the pattern the STACKIT provider validates it with: ^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$"
  }
}

variable "postgres_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach google_sql_database_instance.postgres. The source used private IP or no authorized networks; list the STACKIT network prefixes of the clients."
}

variable "postgres_storage_size" {
  type        = number
  description = "PostgreSQL Flex storage size in GB for google_sql_database_instance.postgres: the source states no disk_size — set the size STACKIT should provision. Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of \"Gigabytes\" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: 5 to 4000 GB, the range of the flavor 2.4 (eu01 catalogue 2026-10-18)."
  validation {
    condition     = var.postgres_storage_size >= 5 && var.postgres_storage_size <= 4000
    error_message = "Must be at least 5 and at most 4000."
  }
}

variable "postgresflex_storage_class" {
  type        = string
  description = "PostgreSQL Flex storage performance class."
}

variable "project_id" {
  type        = string
  description = "STACKIT project ID the migrated resources are created in."
}

variable "rabbitmq_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the one STACKIT RabbitMQ instance that hosts all migrated queues and topics (parameters.sgw_acl). The list replaces STACKIT's default ACL (the STACKIT public or internal IP ranges, which admit every STACKIT customer's addresses): the source's own network boundary (security groups, VPC, access policies) is not carried over, so list the clients. No default."
  validation {
    condition     = length(var.rabbitmq_allowed_cidrs) > 0 && alltrue([for c in var.rabbitmq_allowed_cidrs : can(cidrhost(c, 0))])
    error_message = "At least one CIDR (address/prefix length); an empty list, an empty entry or null would leave the service on its wider default access list."
  }
}

variable "rabbitmq_plan_name" {
  type        = string
  description = "STACKIT RabbitMQ plan (see the RabbitMQ service plans)."
}

variable "rabbitmq_version" {
  type        = string
  description = "STACKIT RabbitMQ version."
}

variable "region" {
  type        = string
  description = "STACKIT region."
  default     = "eu01"
}
