# Generated migration draft by StackToIT — architect review required. Not for apply without review.

terraform {
  # Write-only attributes (e.g. a VPN pre-shared key) need Terraform/OpenTofu 1.11 or later.
  required_version = ">= 1.11.0"

  required_providers {
    stackit = {
      source  = "stackitcloud/stackit"
      version = "0.121.0"
    }
  }
}

provider "stackit" {
  default_region        = var.region
  enable_beta_resources = var.proposal_activategcb_enabled || var.proposal_init_enabled || var.proposal_placeholder_enabled || var.proposal_client_enabled
  experiments           = (var.proposal_django_admin_password_enabled || var.proposal_django_settings_enabled) ? ["iam"] : []
}
