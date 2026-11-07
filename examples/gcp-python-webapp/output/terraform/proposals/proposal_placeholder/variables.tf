# Generated migration draft by StackToIT — architect review required. Not for apply without review.

variable "project_id" {
  type        = string
  description = "The STACKIT project, handed down by the root."
}

variable "values" {
  type = object({
    name = string # Unique name linked to the git instance.
  })
  description = "The values of this proposal. It has no default: nothing is invented."
  nullable    = false
}
