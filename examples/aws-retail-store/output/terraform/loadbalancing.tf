# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.retail_app_ecs.module.alb.aws_lb.this (.terraform/modules/retail_app_ecs.alb/main.tf:5) — RECONFIGURE / MEDIUM
# Internet-facing: an ephemeral public address is requested; use external_address with a stackit_public_ip for a fixed one.
# TODO: EXPOSURE PATH: pool retail-app-ecs-alb-main forwards to the ECS service module.retail_app_ecs.module.ui_service.aws_ecs_service.this, drafted as the workload ui on SKE (kubernetes/ui/manifests.yaml): the pool reaches it through the NodePort Service ui-nodeport of the manifest (node port 30000 → container port 8080, the port the target group module.retail_app_ecs.module.alb.aws_lb_target_group.main forwarded to), so its target_port is 30000 and its targets are the private IPs of the nodes of the cluster (var.alb_target_ips: STACKIT exports no node address to Terraform,
#   and the IPs change as the node pool scales and is updated). The health check of the pool reaches the pods through the same node port. Which exposure path the workload takes is the open decision DEC-GEN-CONVERT-INGRESS-EXPOSURE-PATH (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:target_pools:INGRESS_EXPOSURE_PATH`) (aws.ingress.exposure-path): nodeport-alb-target-pool (this draft), ingress-controller-behind-alb or stackit-alb-ingress-controller.
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb_target_group.main): deregistration_delay = 30 — a STACKIT target pool has name, target_port, targets, active_health_check and tls_config only (pinned provider): no connection draining delay, slow start or load-balancing algorithm — not generated; check that the targets tolerate the STACKIT behaviour.
# WebSocket: an AWS Application Load Balancer proxies WebSocket upgrades (ws, wss) on every listener and rule without a setting … — set web_socket = true on the rules whose targets do. (full text: engineering/trace/loadbalancing.md)
# CLIENT ACCESS: public on source, public on target — the rules of module.retail_app_ecs.module.alb.aws_security_group.this, module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix admit every IPv4 address on the listener port(s) 80, and the load balancer drafted here is public and admits every client: no options.access_control.allowed_source_ranges (pinned provider schema, resource stackit_application_load_balancer: "Application Load Balancer is accessible only from an IP address in this range.", one set for the whole load balancer) is written, it would restrict nothing.
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): security_groups — a STACKIT Application Load Balancer is in no security group, so the attachment of module.retail_app_ecs.module.alb.aws_security_group.this … — the load balancer limits clients by options.access_control.allowed_source_ranges (pinned provider schema, resource stackit_application_load_balancer: "Application Load Balancer is accessible only from an IP address in this range.", one set for the whole load balancer) only. (full text: engineering/trace/loadbalancing.md)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# LEDGER network exposure: internet-facing → public address — PRESERVED
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): enable_http2 = true, desync_mitigation_mode = defensive, xff_header_processing_mode = append, enable_xff_client_port = true — no attribute for it on the STACKIT load balancers (pinned provider).
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): idle_timeout = 60 — the STACKIT Application Load Balancer has no idle timeout; Network Load Balancer listeners take tcp.idle_timeout — not generated (pinned provider).
# TODO: TARGET NETWORK: the targets are the nodes of stackit_ske_cluster.retail_app_ecs_cluster, which sets no network.id, so they are in the network SKE creates for it and in no network of this draft. This load balancer is placed in that network: on a STACKIT project on 2026-11-03 an Application Load Balancer in a drafted network answered 503 and one in the cluster's network answered 200 (the automatic security group of its targets switched off, no rule added; a Network Load Balancer was not tested).
#   disable_target_security_group_assignment = true is that setting and cannot be changed after creation.
# TARGET NETWORK, the order of the apply: the provider exports neither that network nor the addresses of the nodes, so apply the cluster first (execution/deploy.sh applies stackit_ske_cluster.retail_app_ecs_cluster in a stage of its own), then take the network from `stackit network list --project-id <project>` and the addresses from `kubectl get nodes -o wide`, set the two variables and apply the rest. In a project in a Network Area the cluster takes a network.id instead: state project.placement NETWORK_AREA in the target environment and regenerate the draft.
# SECURITY_OBSERVATION Plaintext public listener of module.retail_app_ecs.module.alb.aws_lb.this, port 80 (non-blocking): The source load balancer module.retail_app_ecs.module.alb.aws_lb.this is internet-facing and every listener it states is HTTP (port 80 forwards to its targets, no listener is HTTPS or TLS): clients reach the application without transport encryption.
#   … In the draft (PRESERVED): the drafted listener of stackit_application_load_balancer.retail_app_ecs_alb_this is plain HTTP on port 80, as the source states it; the public address is kept and no HTTPS listener or certificate is added. Hardening, if wanted (a note, not a change; owner Security Architect): serve the application over HTTPS (an HTTPS listener with a certificate, certificate_config in the pinned provider schema) and redirect or close port 80. (full text: engineering/trace/loadbalancing.md)
# trace: TR-c243e261bc0d (engineering/trace/loadbalancing.md#TR-c243e261bc0d)
resource "stackit_application_load_balancer" "retail_app_ecs_alb_this" {
  project_id = var.project_id
  name       = "retail-store-ecs-ui"
  plan_id    = var.alb_plan_id
  networks = [{
    network_id = var.alb_cluster_network_id
    role       = "ROLE_LISTENERS_AND_TARGETS"
  }]
  disable_target_security_group_assignment = true
  listeners = [{
    name     = "listener-1"
    port     = 80
    protocol = "PROTOCOL_HTTP"
    http = {
      hosts = [{
        host = "*"
        rules = [{
          target_pool = "retail-app-ecs-alb-main"
        }]
      }]
    }
  }]
  target_pools = [{
    name        = "retail-app-ecs-alb-main"
    target_port = 30000
    targets     = [for ip in var.alb_target_ips : { ip = ip }]
    active_health_check = {
      healthy_threshold   = 2
      interval            = "30s"
      interval_jitter     = var.alb_interval_jitter
      timeout             = "5s"
      unhealthy_threshold = 3
      http_health_checks = {
        ok_status = var.alb_health_ok_status
        path      = "/actuator/health"
      }
    }
  }]
  options = {
    ephemeral_address = true
  }
  labels = var.alb_labels
}

# from module.retail_app_ecs.module.alb.aws_lb.this.
output "retail_app_ecs_alb_this_external_address" {
  description = "The public address of stackit_application_load_balancer.retail_app_ecs_alb_this (external_address; the address STACKIT allocated when the draft asks for an ephemeral one). Clients reach the listeners on it, and the DNS record of the application points at it at the cutover. Not sensitive."
  value       = stackit_application_load_balancer.retail_app_ecs_alb_this.external_address
}
