# Values of the variables of this draft (written by stacktoit). Remove the # of a line and give the value; run stacktoit again on the same output folder.
# The run takes a value the draft declares and whose type fits, writes it to terraform/target-values.auto.tfvars.json and frees the steps that waited for it. It tells you which values it refused and why.
# A value that exists only after a first apply (the network of a cluster, the addresses of its nodes) can be added later. A line left as it is stays an open variable; nothing here is a default.

# STACKIT machine type of the node pool hosting the migrated container workloads (size from their CPU/memory requests). See https://docs.stackit.cloud/products/compute-engine/server/basics/machine-types/
# containers_machine_type =   # string

# Maximum nodes of the node pool hosting the migrated container workloads.
# containers_nodes_max =   # number

# Minimum nodes of the node pool hosting the migrated container workloads.
# containers_nodes_min =   # number

# DNS-conform bucket name replacing google_storage_bucket.media.
# media_bucket_name =   # string

# CIDRs allowed to reach google_sql_database_instance.postgres. The source used private IP or no authorized networks; list the STACKIT network prefixes of the clients.
# postgres_allowed_cidrs =   # list of string

# PostgreSQL Flex storage size in GB for google_sql_database_instance.postgres: the source states no disk_size — set the size STACKIT should provision. Unit: STACKIT does not state the base of its Gigabyte (the API types the size as a number of "Gigabytes" or without a description); a source size in GiB x 1.074, or in bytes / 10^9, rounded up, is not smaller than the source whichever way the unit is read (100 GiB is 108). Allowed: 5 to 4000 GB, the range of the flavor 2.4 (eu01 catalogue 2026-10-18).
# postgres_storage_size =   # number

# PostgreSQL Flex storage performance class.
# postgresflex_storage_class =   # string

# STACKIT project ID the migrated resources are created in.
# project_id =   # string

# CIDRs allowed to reach the one STACKIT RabbitMQ instance that hosts all migrated queues and topics (parameters.sgw_acl). The list replaces STACKIT's default ACL (the STACKIT public or internal IP ranges, which admit every STACKIT customer's addresses): the source's own network boundary (security groups, VPC, access policies) is not carried over, so list the clients. No default.
# rabbitmq_allowed_cidrs =   # list of string

# STACKIT RabbitMQ plan (see the RabbitMQ service plans).
# rabbitmq_plan_name =   # string

# STACKIT RabbitMQ version.
# rabbitmq_version =   # string
