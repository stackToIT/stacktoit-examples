# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.retail_app_ecs.module.carts_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-carts-service-task-role" for module.retail_app_ecs.module.carts_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-d67986", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (full text: engineering/trace/identity.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this (aws_dynamodb_table), whose own decision the target does not carry (it is in the class redesign), and the semantic contract of aws_iam_role does not read aws_dynamodb_table, so what the reference becomes is not assessed.
# trace: TR-eb88a52a7e37 (engineering/trace/identity.md#TR-eb88a52a7e37)
resource "stackit_service_account" "retail_app_ecs_carts_service_task_role" {
  project_id = var.project_id
  name       = "retail-app-ec-d67986"
}

# Role assignments of service account retail_app_ecs_carts_service_task_role (from the policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.carts_service_task_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].Resource is not known statically (runtime-data)); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-74ede57c41f1 (engineering/trace/identity.md#TR-74ede57c41f1)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_carts_service_task_role" {
  for_each    = toset(var.carts_service_task_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_carts_service_task_role.email
}

# from module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-catalog-service-task-role" for module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-940be8", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (full text: engineering/trace/identity.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-e48f32c8ead8 (engineering/trace/identity.md#TR-e48f32c8ead8)
resource "stackit_service_account" "retail_app_ecs_catalog_service_task_role" {
  project_id = var.project_id
  name       = "retail-app-ec-940be8"
}

# Role assignments of service account retail_app_ecs_catalog_service_task_role (from the policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.catalog_service_task_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].Resource is not known statically (runtime-data)); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-cf63149db4be (engineering/trace/identity.md#TR-cf63149db4be)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_catalog_service_task_role" {
  for_each    = toset(var.catalog_service_task_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_catalog_service_task_role.email
}

# from module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-checkout-service-task-role" for module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-bd3876", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (full text: engineering/trace/identity.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this (aws_dynamodb_table), whose own decision the target does not carry (it is in the class redesign), and the semantic contract of aws_iam_role does not read aws_dynamodb_table, so what the reference becomes is not assessed.
# trace: TR-822b8a98ff0d (engineering/trace/identity.md#TR-822b8a98ff0d)
resource "stackit_service_account" "retail_app_ecs_checkout_service_task_role" {
  project_id = var.project_id
  name       = "retail-app-ec-bd3876"
}

# Role assignments of service account retail_app_ecs_checkout_service_task_role (from the policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.checkout_service_task_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].Resource is not known statically (runtime-data)); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-8e7b4456f29a (engineering/trace/identity.md#TR-8e7b4456f29a)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_checkout_service_task_role" {
  for_each    = toset(var.checkout_service_task_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_checkout_service_task_role.email
}

# from module.retail_app_ecs.module.orders_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-orders-service-task-role" for module.retail_app_ecs.module.orders_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-561956", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (full text: engineering/trace/identity.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-60af0bd02bd2 (engineering/trace/identity.md#TR-60af0bd02bd2)
resource "stackit_service_account" "retail_app_ecs_orders_service_task_role" {
  project_id = var.project_id
  name       = "retail-app-ec-561956"
}

# Role assignments of service account retail_app_ecs_orders_service_task_role (from the policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.orders_service_task_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].Resource is not known statically (runtime-data)); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-cf173263597f (engineering/trace/identity.md#TR-cf173263597f)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_orders_service_task_role" {
  for_each    = toset(var.orders_service_task_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_orders_service_task_role.email
}

# from module.retail_app_ecs.module.ui_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-ui-service-task-role" for module.retail_app_ecs.module.ui_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-c5eb68", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (full text: engineering/trace/identity.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-14c0a005bdbf (engineering/trace/identity.md#TR-14c0a005bdbf)
resource "stackit_service_account" "retail_app_ecs_ui_service_task_role" {
  project_id = var.project_id
  name       = "retail-app-ec-c5eb68"
}

# Role assignments of service account retail_app_ecs_ui_service_task_role (from the policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.ui_service_task_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].Resource is not known statically (runtime-data)); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-759ef9228645 (engineering/trace/identity.md#TR-759ef9228645)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_ui_service_task_role" {
  for_each    = toset(var.ui_service_task_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_ui_service_task_role.email
}

# from module.retail_app_ecs.module.carts_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / LOW
# rule aws.ecs/ecs-to-ske · KB 0.428.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: The application identity of module.retail_app_ecs.module.carts_service.aws_ecs_service.this on STACKIT is decided by the request of the inputs file: target.workload.identity for module.retail_app_ecs.module.carts_service.aws_ecs_service.this. Answer each open one with federated_service_account (a federated identity provider of the account of the task role, for the Kubernetes ServiceAccount of the workload),
#   service_account_key (a key of that account that a person creates and keeps as a secret) or no_workload_identity: until it is answered the draft writes no identity for the pods it is about — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.carts_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.carts_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.catalog_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / LOW
# rule aws.ecs/ecs-to-ske · KB 0.428.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: The application identity of module.retail_app_ecs.module.catalog_service.aws_ecs_service.this on STACKIT is decided by the request of the inputs file: target.workload.identity for module.retail_app_ecs.module.catalog_service.aws_ecs_service.this. Answer each open one with federated_service_account (a federated identity provider of the account of the task role, for the Kubernetes ServiceAccount of the workload),
#   service_account_key (a key of that account that a person creates and keeps as a secret) or no_workload_identity: until it is answered the draft writes no identity for the pods it is about — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.checkout_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / MEDIUM
# rule aws.ecs/ecs-to-ske · KB 0.428.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: The application identity of module.retail_app_ecs.module.checkout_service.aws_ecs_service.this on STACKIT is decided by the request of the inputs file: target.workload.identity for module.retail_app_ecs.module.checkout_service.aws_ecs_service.this. Answer each open one with federated_service_account (a federated identity provider of the account of the task role, for the Kubernetes ServiceAccount of the workload),
#   service_account_key (a key of that account that a person creates and keeps as a secret) or no_workload_identity: until it is answered the draft writes no identity for the pods it is about — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.checkout_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.orders_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / LOW
# rule aws.ecs/ecs-to-ske · KB 0.428.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: The application identity of module.retail_app_ecs.module.orders_service.aws_ecs_service.this on STACKIT is decided by the request of the inputs file: target.workload.identity for module.retail_app_ecs.module.orders_service.aws_ecs_service.this. Answer each open one with federated_service_account (a federated identity provider of the account of the task role, for the Kubernetes ServiceAccount of the workload),
#   service_account_key (a key of that account that a person creates and keeps as a secret) or no_workload_identity: until it is answered the draft writes no identity for the pods it is about — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.orders_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.ui_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / MEDIUM
# rule aws.ecs/ecs-to-ske · KB 0.428.0 · target maturity GA · lifecycle active · evidence internal · review required
# TODO: The application identity of module.retail_app_ecs.module.ui_service.aws_ecs_service.this on STACKIT is decided by the request of the inputs file: target.workload.identity for module.retail_app_ecs.module.ui_service.aws_ecs_service.this. Answer each open one with federated_service_account (a federated identity provider of the account of the task role, for the Kubernetes ServiceAccount of the workload),
#   service_account_key (a key of that account that a person creates and keeps as a secret) or no_workload_identity: until it is answered the draft writes no identity for the pods it is about — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.ui_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.ui_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# rule aws.iam_role/role-workload-execution · KB 0.428.0 · target maturity EXPERIMENTAL · lifecycle active · evidence internal · review required
# No service account is written for module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role: it is the execution role of module.retail_app_ecs.module.carts_service.aws_ecs_task_definition.this and nothing else in this configuration (no task role, output, policy of another principal or other trusted service names it), the role of the platform agent that pulls the images, writes the logs and injects the secrets (AWS, Amazon ECS task execution IAM role: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
#   On STACKIT the cluster does those jobs, with a Harbor pull robot, a Logs access token and a Secrets Manager user, never with a service account; each job is a step below, and every policy of the role is named with the job it served.
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — the role is not written as a service account: its trust admits only the ECS tasks service, which the cluster replaces, and the credentials of its jobs have no name, session duration or permissions boundary of a role.
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_iam_role_policy_attachment.task_execution_role_policy): policy_arn — the attached policy is not a project role: arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy allows ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage on "*" (the image pull, carried by the pull robot and the image pull secret of the step handover/ecs-execution-retail-app-ecs-carts-service-task-execution-role/pull.md) and logs:CreateLogStream, logs:PutLogEvents on "*" (the log writing,
#   carried by the step handover/ecs-execution-retail-app-ecs-carts-service-task-execution-role/logs.md) (AWS Managed Policy Reference, AmazonECSTaskExecutionRolePolicy)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)

# from module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / LOW
# rule aws.iam_role/role-workload-execution · KB 0.428.0 · target maturity EXPERIMENTAL · lifecycle active · evidence internal · review required
# No service account is written for module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role: it is the execution role of module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this and nothing else in this configuration (no task role, output, policy of another principal or other trusted service names it), the role of the platform agent that pulls the images, writes the logs and injects the secrets (AWS, Amazon ECS task execution IAM role: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
#   On STACKIT the cluster does those jobs, with a Harbor pull robot, a Logs access token and a Secrets Manager user, never with a service account; each job is a step below, and every policy of the role is named with the job it served.
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — the role is not written as a service account: its trust admits only the ECS tasks service, which the cluster replaces, and the credentials of its jobs have no name, session duration or permissions boundary of a role.
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role_policy_attachment.task_execution_role_additional): policy_arn — the attached policy is not a project role: module.retail_app_ecs.aws_iam_policy.catalog_policy: it allows secretsmanager:GetSecretValue: the secret injection, carried by the step handover/ecs-execution-retail-app-ecs-catalog-service-task-execution-role/secrets.md; REVIEW: not carried, and no credential grants it: a part of a statement is not visible statically (it may allow more than the actions named, or only some resources);
#   kms:Decrypt*, which is no job of the ECS platform agent
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role_policy_attachment.task_execution_role_policy): policy_arn — the attached policy is not a project role: arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy allows ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage on "*" (the image pull, carried by the pull robot and the image pull secret of the step handover/ecs-execution-retail-app-ecs-catalog-service-task-execution-role/pull.md) and logs:CreateLogStream, logs:PutLogEvents on "*" (the log writing,
#   carried by the step handover/ecs-execution-retail-app-ecs-catalog-service-task-execution-role/logs.md) (AWS Managed Policy Reference, AmazonECSTaskExecutionRolePolicy)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.catalog_db (aws_secretsmanager_secret), whose own decision the target does not carry (it is in the class reconfigure, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch (aws_secretsmanager_secret), whose own decision the target does not carry (it is in the class reconfigure, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.

# from module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# rule aws.iam_role/role-workload-execution · KB 0.428.0 · target maturity EXPERIMENTAL · lifecycle active · evidence internal · review required
# No service account is written for module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role: it is the execution role of module.retail_app_ecs.module.checkout_service.aws_ecs_task_definition.this and nothing else in this configuration (no task role, output, policy of another principal or other trusted service names it), the role of the platform agent that pulls the images, writes the logs and injects the secrets (AWS, Amazon ECS task execution IAM role: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
#   On STACKIT the cluster does those jobs, with a Harbor pull robot, a Logs access token and a Secrets Manager user, never with a service account; each job is a step below, and every policy of the role is named with the job it served.
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — the role is not written as a service account: its trust admits only the ECS tasks service, which the cluster replaces, and the credentials of its jobs have no name, session duration or permissions boundary of a role.
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_iam_role_policy_attachment.task_execution_role_policy): policy_arn — the attached policy is not a project role: arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy allows ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage on "*" (the image pull, carried by the pull robot and the image pull secret of the step handover/ecs-execution-retail-app-ecs-checkout-service-task-execution-role/pull.md) and logs:CreateLogStream,
#   logs:PutLogEvents on "*" (the log writing, carried by the step handover/ecs-execution-retail-app-ecs-checkout-service-task-execution-role/logs.md) (AWS Managed Policy Reference, AmazonECSTaskExecutionRolePolicy)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)

# from module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / LOW
# rule aws.iam_role/role-workload-execution · KB 0.428.0 · target maturity EXPERIMENTAL · lifecycle active · evidence internal · review required
# No service account is written for module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role: it is the execution role of module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this and nothing else in this configuration (no task role, output, policy of another principal or other trusted service names it), the role of the platform agent that pulls the images, writes the logs and injects the secrets (AWS, Amazon ECS task execution IAM role: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
#   On STACKIT the cluster does those jobs, with a Harbor pull robot, a Logs access token and a Secrets Manager user, never with a service account; each job is a step below, and every policy of the role is named with the job it served.
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — the role is not written as a service account: its trust admits only the ECS tasks service, which the cluster replaces, and the credentials of its jobs have no name, session duration or permissions boundary of a role.
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role_policy_attachment.task_execution_role_additional): policy_arn — the attached policy is not a project role: module.retail_app_ecs.aws_iam_policy.orders_policy: it allows secretsmanager:GetSecretValue: the secret injection, carried by the step handover/ecs-execution-retail-app-ecs-orders-service-task-execution-role/secrets.md; REVIEW: not carried, and no credential grants it: a part of a statement is not visible statically (it may allow more than the actions named, or only some resources);
#   kms:Decrypt*, which is no job of the ECS platform agent
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role_policy_attachment.task_execution_role_policy): policy_arn — the attached policy is not a project role: arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy allows ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage on "*" (the image pull, carried by the pull robot and the image pull secret of the step handover/ecs-execution-retail-app-ecs-orders-service-task-execution-role/pull.md) and logs:CreateLogStream, logs:PutLogEvents on "*" (the log writing,
#   carried by the step handover/ecs-execution-retail-app-ecs-orders-service-task-execution-role/logs.md) (AWS Managed Policy Reference, AmazonECSTaskExecutionRolePolicy)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.mq (aws_secretsmanager_secret), whose own decision the target does not carry (it is in the class reconfigure, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.orders_db (aws_secretsmanager_secret), whose own decision the target does not carry (it is in the class reconfigure, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.

# from module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# rule aws.iam_role/role-workload-execution · KB 0.428.0 · target maturity EXPERIMENTAL · lifecycle active · evidence internal · review required
# No service account is written for module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role: it is the execution role of module.retail_app_ecs.module.ui_service.aws_ecs_task_definition.this and nothing else in this configuration (no task role, output, policy of another principal or other trusted service names it), the role of the platform agent that pulls the images, writes the logs and injects the secrets (AWS, Amazon ECS task execution IAM role: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html).
#   On STACKIT the cluster does those jobs, with a Harbor pull robot, a Logs access token and a Secrets Manager user, never with a service account; each job is a step below, and every policy of the role is named with the job it served.
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — the role is not written as a service account: its trust admits only the ECS tasks service, which the cluster replaces, and the credentials of its jobs have no name, session duration or permissions boundary of a role.
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_iam_role_policy_attachment.task_execution_role_policy): policy_arn — the attached policy is not a project role: arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy allows ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer, ecr:BatchGetImage on "*" (the image pull, carried by the pull robot and the image pull secret of the step handover/ecs-execution-retail-app-ecs-ui-service-task-execution-role/pull.md) and logs:CreateLogStream, logs:PutLogEvents on "*" (the log writing,
#   carried by the step handover/ecs-execution-retail-app-ecs-ui-service-task-execution-role/logs.md) (AWS Managed Policy Reference, AmazonECSTaskExecutionRolePolicy)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)

# from module.retail_app_ecs.module.carts_service.aws_iam_role.task_role.
output "retail_app_ecs_carts_service_task_role_email" {
  description = "The e-mail of the service account stackit_service_account.retail_app_ecs_carts_service_task_role (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.retail_app_ecs_carts_service_task_role.email
}

# from module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role.
output "retail_app_ecs_catalog_service_task_role_email" {
  description = "The e-mail of the service account stackit_service_account.retail_app_ecs_catalog_service_task_role (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.retail_app_ecs_catalog_service_task_role.email
}

# from module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role.
output "retail_app_ecs_checkout_service_task_role_email" {
  description = "The e-mail of the service account stackit_service_account.retail_app_ecs_checkout_service_task_role (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.retail_app_ecs_checkout_service_task_role.email
}

# from module.retail_app_ecs.module.orders_service.aws_iam_role.task_role.
output "retail_app_ecs_orders_service_task_role_email" {
  description = "The e-mail of the service account stackit_service_account.retail_app_ecs_orders_service_task_role (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.retail_app_ecs_orders_service_task_role.email
}

# from module.retail_app_ecs.module.ui_service.aws_iam_role.task_role.
output "retail_app_ecs_ui_service_task_role_email" {
  description = "The e-mail of the service account stackit_service_account.retail_app_ecs_ui_service_task_role (email, assigned by STACKIT). No manifest of this draft asks for it now; a ServiceAccount of a federated workload carries it as the annotation workload-identity.stackit.cloud/service-account-email (REQUIRED_<APP>_SERVICE_ACCOUNT_EMAIL in its manifest) once the identity of the service is answered federated_service_account. Not sensitive."
  value       = stackit_service_account.retail_app_ecs_ui_service_task_role.email
}
