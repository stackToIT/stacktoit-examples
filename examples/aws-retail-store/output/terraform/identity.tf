# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-carts-service-task-execution-role" for module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-e66809", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-935427f3024d (engineering/trace/identity.md#TR-935427f3024d)
resource "stackit_service_account" "retail_app_ecs_carts_service_task_execution_role" {
  project_id = var.project_id
  name       = "retail-app-ec-e66809"
}

# Role assignments of service account retail_app_ecs_carts_service_task_execution_role (from the policies of module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.carts_task_execution_project_roles, chosen by the architect.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-58f6779c70bf (engineering/trace/identity.md#TR-58f6779c70bf)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_carts_service_task_execution_role" {
  for_each    = toset(var.carts_task_execution_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_carts_service_task_execution_role.email
}

# from module.retail_app_ecs.module.carts_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-carts-service-task-role" for module.retail_app_ecs.module.carts_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-d67986", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this (aws_dynamodb_table), whose own decision the target does not carry (it is REDESIGN), and the semantic contract of aws_iam_role does not read aws_dynamodb_table, so what the reference becomes is not assessed.
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

# from module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-catalog-service-task-execution-role" for module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-bf495d", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.catalog_db (aws_secretsmanager_secret), whose own decision the target does not carry (it is RECONFIGURE, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch (aws_secretsmanager_secret), whose own decision the target does not carry (it is RECONFIGURE, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# trace: TR-089026082d6f (engineering/trace/identity.md#TR-089026082d6f)
resource "stackit_service_account" "retail_app_ecs_catalog_service_task_execution_role" {
  project_id = var.project_id
  name       = "retail-app-ec-bf495d"
}

# Role assignments of service account retail_app_ecs_catalog_service_task_execution_role (from the policies of module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.catalog_task_execution_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].resources is not known statically); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-2eebb342bc5c (engineering/trace/identity.md#TR-2eebb342bc5c)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_catalog_service_task_execution_role" {
  for_each    = toset(var.catalog_task_execution_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_catalog_service_task_execution_role.email
}

# from module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-catalog-service-task-role" for module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-940be8", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
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

# from module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-checkout-service-task-execution-role" for module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-7b153c", cut and told apart by a suffix of the SHA-256 of the source address
#   — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-101825075cda (engineering/trace/identity.md#TR-101825075cda)
resource "stackit_service_account" "retail_app_ecs_checkout_service_task_execution_role" {
  project_id = var.project_id
  name       = "retail-app-ec-7b153c"
}

# Role assignments of service account retail_app_ecs_checkout_service_task_execution_role (from the policies of module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.checkout_task_execution_project_roles, chosen by the architect.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-b9a8861fdbd3 (engineering/trace/identity.md#TR-b9a8861fdbd3)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_checkout_service_task_execution_role" {
  for_each    = toset(var.checkout_task_execution_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_checkout_service_task_execution_role.email
}

# from module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-checkout-service-task-role" for module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-bd3876", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.dependencies.module.dynamodb_carts.aws_dynamodb_table.this (aws_dynamodb_table), whose own decision the target does not carry (it is REDESIGN), and the semantic contract of aws_iam_role does not read aws_dynamodb_table, so what the reference becomes is not assessed.
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

# from module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / LOW
# TODO: the draft derives the service account name "retail-app-ecs-orders-service-task-execution-role" for module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-a8100a", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.mq (aws_secretsmanager_secret), whose own decision the target does not carry (it is RECONFIGURE, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# WARNING linked-dependency-unread: This unit names module.retail_app_ecs.aws_secretsmanager_secret.orders_db (aws_secretsmanager_secret), whose own decision the target does not carry (it is RECONFIGURE, but the converter does not draft this aws_secretsmanager_secret (the generator skips this case, or only records it against a shared instance or a note) and the Terraform draft does not create it; a STACKIT API script (Secrets Manager Vault-compatible API: WriteSecret;
#   execution/api/secrets-manager-vault/) makes an object for it outside Terraform, and runs only once the decision to opt in to the Secrets Manager Vault-compatible API (an API whose maturity is not established) is accepted and the inputs the script reads from a person are set; the script gives a reference no Terraform address to resolve to, so this finding stays), and the semantic contract of aws_iam_role does not read aws_secretsmanager_secret, so what the reference becomes is not assessed.
# trace: TR-0054e8101f59 (engineering/trace/identity.md#TR-0054e8101f59)
resource "stackit_service_account" "retail_app_ecs_orders_service_task_execution_role" {
  project_id = var.project_id
  name       = "retail-app-ec-a8100a"
}

# Role assignments of service account retail_app_ecs_orders_service_task_execution_role (from the policies of module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.orders_task_execution_project_roles, chosen by the architect.
# SCOPE: the source may limit permissions to specific resources (Statement[0].resources is not known statically); a project role assignment applies to the whole project — use per-resource role bindings where the STACKIT service offers them.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-a77098085913 (engineering/trace/identity.md#TR-a77098085913)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_orders_service_task_execution_role" {
  for_each    = toset(var.orders_task_execution_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_orders_service_task_execution_role.email
}

# from module.retail_app_ecs.module.orders_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-orders-service-task-role" for module.retail_app_ecs.module.orders_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-561956", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
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

# from module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role (../../lib/ecs/service/iam.tf:14) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-ui-service-task-execution-role" for module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-f7f0f9", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-02dcd9e3db54 (engineering/trace/identity.md#TR-02dcd9e3db54)
resource "stackit_service_account" "retail_app_ecs_ui_service_task_execution_role" {
  project_id = var.project_id
  name       = "retail-app-ec-f7f0f9"
}

# Role assignments of service account retail_app_ecs_ui_service_task_execution_role (from the policies of module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role); provider experiment "iam".
# AWS actions do not translate into STACKIT roles one to one: the roles are var.ui_task_execution_project_roles, chosen by the architect.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
# trace: TR-be8af2d2983d (engineering/trace/identity.md#TR-be8af2d2983d)
resource "stackit_authorization_project_role_assignment" "retail_app_ecs_ui_service_task_execution_role" {
  for_each    = toset(var.ui_task_execution_project_roles)
  resource_id = var.project_id
  role        = each.value
  subject     = stackit_service_account.retail_app_ecs_ui_service_task_execution_role.email
}

# from module.retail_app_ecs.module.ui_service.aws_iam_role.task_role (../../lib/ecs/service/iam.tf:31) — RECONFIGURE / MEDIUM
# TODO: the draft derives the service account name "retail-app-ecs-ui-service-task-role" for module.retail_app_ecs.module.ui_service.aws_iam_role.task_role from its address (the name the source role itself carries, if it has one, is not used): a STACKIT service account name has at most 20 characters (lowercase letters, digits and single dashes) and is unique in a project (a second account of the same name is refused), so the draft names the account "retail-app-ec-c5eb68", cut and told apart by a suffix of the SHA-256 of the source address — set the name you want.
# The permissions of the source policies become the project role assignments below (provider experiment "iam").
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_iam_role.task_role): assume_role_policy, name = (reads a variable; its default is not printed) — stackit_service_account has a name and a project only (pinned provider): no trust policy, path, session duration or permissions boundary. … references to the role's ARN must be updated. (shortened: the whole reason is in the trace of this block)
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
# rule aws.ecs/ecs-to-ske · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# TODO: Decide how module.retail_app_ecs.module.carts_service.aws_ecs_service.this pulls images, injects secrets and writes logs: the platform agent's role has no STACKIT counterpart to attach — the role is the platform agent's identity, not the application's (execution_role_arn of module.retail_app_ecs.module.carts_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.carts_service.aws_iam_role.task_execution_role).
#   a platform agent's identity is not an application identity and has no STACKIT counterpart; the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
# TODO: Decide how module.retail_app_ecs.module.carts_service.aws_ecs_service.this gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.carts_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.carts_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.catalog_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / LOW
# rule aws.ecs/ecs-to-ske · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# TODO: Decide how module.retail_app_ecs.module.catalog_service.aws_ecs_service.this pulls images, injects secrets and writes logs: the platform agent's role has no STACKIT counterpart to attach — the role is the platform agent's identity, not the application's (execution_role_arn of module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.catalog_service.aws_iam_role.task_execution_role).
#   a platform agent's identity is not an application identity and has no STACKIT counterpart; the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
# TODO: Decide how module.retail_app_ecs.module.catalog_service.aws_ecs_service.this gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.catalog_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.checkout_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / MEDIUM
# rule aws.ecs/ecs-to-ske · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# TODO: Decide how module.retail_app_ecs.module.checkout_service.aws_ecs_service.this pulls images, injects secrets and writes logs: the platform agent's role has no STACKIT counterpart to attach — the role is the platform agent's identity, not the application's (execution_role_arn of module.retail_app_ecs.module.checkout_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.checkout_service.aws_iam_role.task_execution_role).
#   a platform agent's identity is not an application identity and has no STACKIT counterpart; the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
# TODO: Decide how module.retail_app_ecs.module.checkout_service.aws_ecs_service.this gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.checkout_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.checkout_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.orders_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / LOW
# rule aws.ecs/ecs-to-ske · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# TODO: Decide how module.retail_app_ecs.module.orders_service.aws_ecs_service.this pulls images, injects secrets and writes logs: the platform agent's role has no STACKIT counterpart to attach — the role is the platform agent's identity, not the application's (execution_role_arn of module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.orders_service.aws_iam_role.task_execution_role).
#   a platform agent's identity is not an application identity and has no STACKIT counterpart; the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
# TODO: Decide how module.retail_app_ecs.module.orders_service.aws_ecs_service.this gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.orders_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)

# from module.retail_app_ecs.module.ui_service.aws_ecs_service.this (../../lib/ecs/service/ecs.tf:136) — REPLATFORM / MEDIUM
# rule aws.ecs/ecs-to-ske · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# TODO: Decide how module.retail_app_ecs.module.ui_service.aws_ecs_service.this pulls images, injects secrets and writes logs: the platform agent's role has no STACKIT counterpart to attach — the role is the platform agent's identity, not the application's (execution_role_arn of module.retail_app_ecs.module.ui_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.ui_service.aws_iam_role.task_execution_role).
#   a platform agent's identity is not an application identity and has no STACKIT counterpart; the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
# TODO: Decide how module.retail_app_ecs.module.ui_service.aws_ecs_service.this gets its application identity on STACKIT (a service account of its own, workload federation): the draft does not write it — the workload is a container service, not a server an account is attached to (task_role_arn of module.retail_app_ecs.module.ui_service.aws_ecs_task_definition.this names module.retail_app_ecs.module.ui_service.aws_iam_role.task_role).
#   the draft writes service accounts for servers (the EC2 family); the identities of containers, functions and clusters are stated as facts and left to a person (phase BEFORE_PILOT, owner Identity Architect)
