# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# One Secrets Manager instance holds all migrated secrets; recreate each secret as a key in it.
# NOT CARRIED (google_secret_manager_secret.django_admin_password): replication, secret_id — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_admin_password writes it into the Secrets Manager instance from a document you supply … so a grant of one principal on one secret is decided, not copied. (full text: engineering/trace/security.md)
# NOT CARRIED (google_secret_manager_secret_iam_binding.django_admin_password): members, role = roles/secretmanager.secretAccessor — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_admin_password writes it into the Secrets Manager instance from a document … Proposed, switched off until it is decided: proposals/proposal_django_admin_password, switch proposal_django_admin_password_enabled. (full text: engineering/trace/security.md)
# NOT CARRIED (google_secret_manager_secret_version.django_admin_password): secret_data — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_admin_password writes it into the Secrets Manager instance from a document you supply … so a grant of one principal on one secret is decided, not copied. (full text: engineering/trace/security.md)
# NOT CARRIED (google_secret_manager_secret.django_settings): replication, secret_id — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_settings writes it into the Secrets Manager instance from a document you supply … so a grant of one principal on one secret is decided, not copied. (full text: engineering/trace/security.md)
# NOT CARRIED (google_secret_manager_secret_iam_binding.django_settings): members, role = roles/secretmanager.secretAccessor — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_settings writes it into the Secrets Manager instance from a document you supply … Proposed, switched off until it is decided: proposals/proposal_django_settings, switch proposal_django_settings_enabled. (full text: engineering/trace/security.md)
# NOT CARRIED (google_secret_manager_secret_version.django_settings): secret_data — the API step API/secrets-manager-vault/WriteSecret/google_secret_manager_secret.django_settings writes it into the Secrets Manager instance from a document you supply … so a grant of one principal on one secret is decided, not copied. (full text: engineering/trace/security.md)
# google_secret_manager_secret.django_admin_password: WARNING secret-iam-access: The secret has grants for individual principals.
# google_secret_manager_secret.django_admin_password: WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# google_secret_manager_secret.django_settings: WARNING secret-iam-access: The secret has grants for individual principals.
# google_secret_manager_secret.django_settings: WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# replaces: google_secret_manager_secret.django_admin_password, google_secret_manager_secret.django_settings
# trace: TR-20eecaf8afaa (engineering/trace/security.md#TR-20eecaf8afaa)
resource "stackit_secretsmanager_instance" "migrated_secrets" {
  project_id = var.project_id
  name       = "migrated-secrets"
}

# The user the API steps of the execution plan log in as to write the migrated secrets into the Secrets Manager instance.
# DEFAULT: write_enabled = true gives this user write access to the secrets engine of the whole instance (the provider schema: "If true, the user has writeaccess to the secrets engine"), so every secret of the instance, not one … (full text: engineering/trace/security.md)
# trace: TR-d46bac8a52a7 (engineering/trace/security.md#TR-d46bac8a52a7)
resource "stackit_secretsmanager_user" "migration" {
  project_id    = var.project_id
  instance_id   = stackit_secretsmanager_instance.migrated_secrets.instance_id
  description   = "StackToIT migration user: writes the migrated secrets; delete it afterwards"
  write_enabled = true
}

# from google_secret_manager_secret.django_admin_password.
output "stackit_secretsmanager_instance_migrated_secrets_instance_id" {
  description = "The instance_id of stackit_secretsmanager_instance.migrated_secrets. An API step of the execution plan reads it (tofu output -raw stackit_secretsmanager_instance_migrated_secrets_instance_id) when its input variable is not set. Not sensitive: it is an identifier or a name, never a secret."
  value       = stackit_secretsmanager_instance.migrated_secrets.instance_id
}

# from google_secret_manager_secret.django_admin_password.
output "stackit_secretsmanager_user_migration_password" {
  description = "The password STACKIT generated for stackit_secretsmanager_user.migration. An API step of the execution plan that writes a migrated secret reads it (tofu output -json stackit_secretsmanager_user_migration_password) when its input variable is not set, and prints it nowhere. Sensitive: tofu output hides it from the plan, the state holds it in plain text; delete the user once the secrets are written."
  value       = stackit_secretsmanager_user.migration.password
  sensitive   = true
}

# from google_secret_manager_secret.django_admin_password.
output "stackit_secretsmanager_user_migration_username" {
  description = "The username of stackit_secretsmanager_user.migration. An API step of the execution plan reads it (tofu output -raw stackit_secretsmanager_user_migration_username) when its input variable is not set. Not sensitive: it is an identifier or a name, never a secret."
  value       = stackit_secretsmanager_user.migration.username
}
