# Generated migration draft by StackToIT — architect review required. Not for apply without review.

variable "project_id" {
  type        = string
  description = "The STACKIT project, handed down by the root."
}

variable "values" {
  type = object({
    write_authorization_project_role_assignment             = bool   # true writes stackit_authorization_project_role_assignment and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    authorization_project_role_assignment_resource_id       = string # stackit_authorization_project_role_assignment: Project Resource to assign the role to.
    authorization_project_role_assignment_role              = string # stackit_authorization_project_role_assignment: Role to be assigned.
    authorization_project_role_assignment_subject           = string # stackit_authorization_project_role_assignment: Identifier of user, service account or client.
    write_authorization_folder_role_assignment              = bool   # true writes stackit_authorization_folder_role_assignment and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    authorization_folder_role_assignment_resource_id        = string # stackit_authorization_folder_role_assignment: Folder Resource to assign the role to.
    authorization_folder_role_assignment_role               = string # stackit_authorization_folder_role_assignment: Role to be assigned.
    authorization_folder_role_assignment_subject            = string # stackit_authorization_folder_role_assignment: Identifier of user, service account or client.
    write_authorization_organization_role_assignment        = bool   # true writes stackit_authorization_organization_role_assignment and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    authorization_organization_role_assignment_resource_id  = string # stackit_authorization_organization_role_assignment: Organization Resource to assign the role to.
    authorization_organization_role_assignment_role         = string # stackit_authorization_organization_role_assignment: Role to be assigned.
    authorization_organization_role_assignment_subject      = string # stackit_authorization_organization_role_assignment: Identifier of user, service account or client.
    write_secretsmanager_secret_group_role_binding_v1       = bool   # true writes stackit_secretsmanager_secret_group_role_binding_v1 and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    secretsmanager_secret_group_role_binding_v1_resource_id = string # stackit_secretsmanager_secret_group_role_binding_v1: The identifier of the resource to apply this role binding to.
    secretsmanager_secret_group_role_binding_v1_role        = string # stackit_secretsmanager_secret_group_role_binding_v1: A valid role defined for the resource.
    secretsmanager_secret_group_role_binding_v1_subject     = string # stackit_secretsmanager_secret_group_role_binding_v1: Identifier of user, service account or client.
    write_secretsmanager_instance_role_binding_v1           = bool   # true writes stackit_secretsmanager_instance_role_binding_v1 and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    secretsmanager_instance_role_binding_v1_resource_id     = string # stackit_secretsmanager_instance_role_binding_v1: The identifier of the resource to apply this role binding to.
    secretsmanager_instance_role_binding_v1_role            = string # stackit_secretsmanager_instance_role_binding_v1: A valid role defined for the resource.
    secretsmanager_instance_role_binding_v1_subject         = string # stackit_secretsmanager_instance_role_binding_v1: Identifier of user, service account or client.
  })
  description = "The values of this proposal. It has no default: nothing is invented."
  nullable    = false
}
