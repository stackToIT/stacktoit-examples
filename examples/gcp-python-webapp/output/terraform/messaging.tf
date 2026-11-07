# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# One RabbitMQ instance hosts all migrated topics as exchanges and subscriptions as queues.
# NOT CARRIED (google_pubsub_topic.faux): name — the topic becomes an exchange and its subscriptions queues of the shared RabbitMQ instance, created in RabbitMQ by hand (not by this draft): names, delivery, retention and push settings are not generated.
# google_pubsub_topic.faux: WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# replaces: google_pubsub_topic.faux
# trace: TR-4a61e547964d (engineering/trace/messaging.md#TR-4a61e547964d)
resource "stackit_rabbitmq_instance" "messaging" {
  project_id = var.project_id
  name       = "messaging"
  plan_name  = var.rabbitmq_plan_name
  version    = var.rabbitmq_version
  parameters = {
    sgw_acl = join(",", var.rabbitmq_allowed_cidrs)
  }
}
