# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# Proposed, switched off: a STACKIT alternative for the the members of one role on the Secret Manager secret, which is not equal to the source.
# Difference: A STACKIT role assignment is not a grant on the Secret Manager secret. It gives one user, group or service account one STACKIT role on a whole project, folder or organisation. The role is a set of STACKIT permissions, not the Google role, and no table maps one to the other. It has no condition and no public member, so what the grant gave to a Google group, a domain, a federated identity or everyone is named again, and the access reaches more than the Secret Manager secret.
#   A binding on a secret group applies to every secret in the group, so it is wider than a grant on one secret unless the secret has a group of its own, and its roles are Secrets Manager roles. The binding was authoritative for its role: STACKIT role assignments are additive, so a person who holds the role through another assignment keeps it, and removing such people is a step of a person.
# To decide: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# Written for google_secret_manager_secret_iam_binding.django_settings, beside the draft of google_secret_manager_secret.django_settings, which it changes nothing of.
# NOT CARRIED (google_secret_manager_secret_iam_binding.django_settings): members: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (authorization_project_role_assignment_resource_id, authorization_project_role_assignment_role, authorization_project_role_assignment_subject, authorization_folder_role_assignment_resource_id, authorization_folder_role_assignment_role, authorization_folder_role_assignment_subject, authorization_organization_role_assignment_resource_id,
#   authorization_organization_role_assignment_role and 7 more), and every other setting is the customer's to add
# NOT CARRIED (google_secret_manager_secret_iam_binding.django_settings): role: no value of the source is copied: the module asks the customer for the settings the pinned provider requires of its resources (authorization_project_role_assignment_resource_id, authorization_project_role_assignment_role, authorization_project_role_assignment_subject, authorization_folder_role_assignment_resource_id, authorization_folder_role_assignment_role, authorization_folder_role_assignment_subject, authorization_organization_role_assignment_resource_id,
#   authorization_organization_role_assignment_role and 7 more), and every other setting is the customer's to add

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_authorization_project_role_assignment and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# The row names more than one resource: this block is written only when write_authorization_project_role_assignment is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_project_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
resource "stackit_authorization_project_role_assignment" "this" {
  count       = var.values.write_authorization_project_role_assignment ? 1 : 0
  resource_id = var.values.authorization_project_role_assignment_resource_id
  role        = var.values.authorization_project_role_assignment_role
  subject     = var.values.authorization_project_role_assignment_subject
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_authorization_folder_role_assignment and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# The row names more than one resource: this block is written only when write_authorization_folder_role_assignment is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_folder_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
resource "stackit_authorization_folder_role_assignment" "this" {
  count       = var.values.write_authorization_folder_role_assignment ? 1 : 0
  resource_id = var.values.authorization_folder_role_assignment_resource_id
  role        = var.values.authorization_folder_role_assignment_role
  subject     = var.values.authorization_folder_role_assignment_subject
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_authorization_organization_role_assignment and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# The row names more than one resource: this block is written only when write_authorization_organization_role_assignment is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: EXPERIMENTAL — stackit_authorization_organization_role_assignment is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
resource "stackit_authorization_organization_role_assignment" "this" {
  count       = var.values.write_authorization_organization_role_assignment ? 1 : 0
  resource_id = var.values.authorization_organization_role_assignment_resource_id
  role        = var.values.authorization_organization_role_assignment_role
  subject     = var.values.authorization_organization_role_assignment_subject
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_secretsmanager_secret_group_role_binding_v1 and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# The row names more than one resource: this block is written only when write_secretsmanager_secret_group_role_binding_v1 is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: EXPERIMENTAL — stackit_secretsmanager_secret_group_role_binding_v1 is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
resource "stackit_secretsmanager_secret_group_role_binding_v1" "this" {
  count       = var.values.write_secretsmanager_secret_group_role_binding_v1 ? 1 : 0
  resource_id = var.values.secretsmanager_secret_group_role_binding_v1_resource_id
  role        = var.values.secretsmanager_secret_group_role_binding_v1_role
  subject     = var.values.secretsmanager_secret_group_role_binding_v1_subject
}

# Written from the pinned STACKIT provider schema: the settings the provider requires of stackit_secretsmanager_instance_role_binding_v1 and no others. The module writes the required settings only; every optional setting is the customer's to add.
# Nothing is copied from the source and no value is invented: each setting is an input with no default, which the customer gives.
# The customer decides: Which STACKIT role, on which project, folder or organisation, gives the same people the access they need on the Secret Manager secret, knowing it covers everything in that scope; which STACKIT users, groups or service accounts take the place of Google groups, domains, federated identities and a public member; and whether the grant ends with the Secret Manager secret when it has no replacement. For secrets: which secret group holds the secret, who else shares that group, and which Secrets Manager role and subject take the grant.
#   Whether people who hold the role through another assignment keep it.
# The row names more than one resource: this block is written only when write_secretsmanager_instance_role_binding_v1 is true, and the module never writes more than the customer asks for.
# TARGET MATURITY: EXPERIMENTAL — stackit_secretsmanager_instance_role_binding_v1 is part of the experimental feature "iam" of the pinned STACKIT provider: "likely going to undergo significant changes or be removed in the future" (enabled in terraform.tf experiments).
resource "stackit_secretsmanager_instance_role_binding_v1" "this" {
  count       = var.values.write_secretsmanager_instance_role_binding_v1 ? 1 : 0
  resource_id = var.values.secretsmanager_instance_role_binding_v1_resource_id
  role        = var.values.secretsmanager_instance_role_binding_v1_role
  subject     = var.values.secretsmanager_instance_role_binding_v1_subject
}
