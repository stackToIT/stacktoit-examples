# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# from module.retail_app_ecs.module.alb.aws_lb.this (.terraform/modules/retail_app_ecs.alb/main.tf:5) — RECONFIGURE / MEDIUM
# Internet-facing: an ephemeral public address is requested; use external_address with a stackit_public_ip for a fixed one.
# TODO: the source load balancer names every instance of the repeated subnet module.vpc.module.vpc.aws_subnet.public, each a network of its own on STACKIT; the draft places the load balancer in one network (its layout choice; other layouts are a redesign): which instance is the placement is a decision; network_id is selected by the required variable var.retail_app_ecs_alb_this_network_id_target — set it to the index of the instance that is the network of the load balancer's listeners and targets.
# TODO: EXPOSURE PATH: pool retail-app-ecs-alb-main forwards to the ECS service module.retail_app_ecs.module.ui_service.aws_ecs_service.this, drafted as the workload ui on SKE (kubernetes/ui/manifests.yaml): the pool reaches it through the NodePort Service ui-nodeport of the manifest (node port 30000 → container port 8080, the port the target group module.retail_app_ecs.module.alb.aws_lb_target_group.main forwarded to),
#   so its target_port is 30000 and its targets are the private IPs of the nodes of the cluster (var.retail_app_ecs_alb_this_target_ips: STACKIT exports no node address to Terraform, and the IPs change as the node pool scales and is updated). The health check of the pool reaches the pods through the same node port.
#   Which exposure path the workload takes is the open decision DEC-GEN-CONVERT-INGRESS-EXPOSURE-PATH (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:target_pools:INGRESS_EXPOSURE_PATH`) (aws.ingress.exposure-path): nodeport-alb-target-pool (this draft), ingress-controller-behind-alb or stackit-alb-ingress-controller.
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb_target_group.main): deregistration_delay = 30 — a STACKIT target pool has name, target_port, targets, active_health_check and tls_config only (pinned provider): no connection draining delay, slow start or load-balancing algorithm — not generated; check that the targets tolerate the STACKIT behaviour.
# WebSocket: an AWS Application Load Balancer proxies WebSocket upgrades (ws, wss) on every listener and rule without a setting … — set web_socket = true on the rules whose targets do.
# CLIENT ACCESS: public on source, public on target — the rules of module.retail_app_ecs.module.alb.aws_security_group.this, module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix admit every IPv4 address on the listener port(s) 80 …
# CLIENT ACCESS (assumed): the network ACLs of the subnets of module.retail_app_ecs.module.alb.aws_lb.this is not managed by this source and is taken as unrestricted — not verified; the client access stated for stackit_application_load_balancer.retail_app_ecs_alb_this is an assumption about it and not a proof.
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): security_groups — a STACKIT Application Load Balancer is in no security group, so the attachment of module.retail_app_ecs.module.alb.aws_security_group.this … — the load balancer limits clients by options.access_control.allowed_source_ranges (pinned provider schema, resource stackit_application_load_balancer: "Application Load Balancer is accessible only from an IP address in this range.", one set for the whole load balancer) only. (shortened: the whole reason is in the trace of this block)
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# LEDGER network exposure: internet-facing → public address (ASSUMPTION: the unmanaged default network ACL of the subnets of module.retail_app_ecs.module.alb.aws_lb.this is taken as unrestricted, not verified) — REVIEW
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): enable_http2 = true, desync_mitigation_mode = defensive, xff_header_processing_mode = append, enable_xff_client_port = true — no attribute for it on the STACKIT load balancers (pinned provider).
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_lb.this): idle_timeout = 60 — the STACKIT Application Load Balancer has no idle timeout; Network Load Balancer listeners take tcp.idle_timeout — not generated (pinned provider).
# SECURITY_OBSERVATION Plaintext public listener of module.retail_app_ecs.module.alb.aws_lb.this, port 80 (non-blocking): The source load balancer module.retail_app_ecs.module.alb.aws_lb.this is internet-facing and every listener it states is HTTP …
# TODO: module.retail_app_ecs.module.alb.aws_lb.this: which instance of stackit_network.vpc_vpc_public the networks of this block means is not visible in the source (it is repeated); set var.retail_app_ecs_alb_this_network_id_target to its index — no instance is assumed (open decision DEC-GEN-CONVERT-AMBIGUOUS-INSTANCE-SELECTION (alias `convert:module.retail_app_ecs.module.alb.aws_lb.this:network_id:AMBIGUOUS_INSTANCE_SELECTION`)).
# trace: TR-c243e261bc0d (engineering/trace/loadbalancing.md#TR-c243e261bc0d)
resource "stackit_application_load_balancer" "retail_app_ecs_alb_this" {
  project_id = var.project_id
  name       = "retail-store-ecs-ui"
  plan_id    = var.retail_app_ecs_alb_this_plan_id
  networks = [{
    network_id = stackit_network.vpc_vpc_public[var.retail_app_ecs_alb_this_network_id_target].network_id
    role       = "ROLE_LISTENERS_AND_TARGETS"
  }]
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
    targets     = [for ip in var.retail_app_ecs_alb_this_target_ips : { ip = ip }]
    active_health_check = {
      healthy_threshold   = 2
      interval            = "30s"
      interval_jitter     = var.alb_interval_jitter
      timeout             = "5s"
      unhealthy_threshold = 3
      http_health_checks = {
        ok_status = var.retail_app_ecs_alb_this_health_ok_status
        path      = "/actuator/health"
      }
    }
  }]
  options = {
    ephemeral_address = true
  }
  labels = var.retail_app_ecs_alb_this_labels
}
