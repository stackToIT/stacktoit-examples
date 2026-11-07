# Generated migration draft by StackToIT — architect review required. Not for apply without review.

variable "project_id" {
  type        = string
  description = "The STACKIT project, handed down by the root."
}

variable "values" {
  type = object({
    write_objectstorage_bucket        = bool                                                                    # true writes stackit_objectstorage_bucket and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    objectstorage_bucket_name         = string                                                                  # stackit_objectstorage_bucket: The bucket name.
    write_cdn_distribution            = bool                                                                    # true writes stackit_cdn_distribution and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    cdn_distribution_config           = object({ backend = object({ type = string }), regions = list(string) }) # stackit_cdn_distribution: The distribution configuration
    write_cdn_custom_domain           = bool                                                                    # true writes stackit_cdn_custom_domain and false writes none of it: the row names more than one resource, and the customer says which of them the design needs
    cdn_custom_domain_distribution_id = string                                                                  # stackit_cdn_custom_domain: CDN distribution ID
    cdn_custom_domain_name            = string                                                                  # stackit_cdn_custom_domain: required by stackit_cdn_custom_domain
  })
  description = "The values of this proposal. It has no default: nothing is invented."
  nullable    = false
}
