# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# TOPOLOGY (STACKIT_STABLE profile): the estate has one VPC, module.vpc.module.vpc.aws_vpc.this. On STACKIT the project the draft is
# created in (var.project_id) is that VPC's boundary: its subnets become stackit_network resources (their number is not visible
# statically). The project's virtual router routes between all of its networks ("Routing between multiple Virtual Networks in the
# same project", core-networking architecture), and the security groups of the draft are project-wide. A routing table is not:
# stackit_routing_table is a Network Area resource (organization_id and network_area_id, pinned provider), so the draft puts the
# routing tables it makes in the Network Area, and only STACKIT's default routing is the project's. The experimental STACKIT VPC
# (stackit_vpc, pinned provider) is not used.
# Target: stackit provider 0.121.0; knowledge base 0.385.0

# from module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix (.terraform/modules/retail_app_ecs.alb_sg/main.tf:37) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# name derived from the address of module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix[0]: the source group has no name of its own: AWS names it from the name_prefix "retail-store-ecs-ui-" and a random suffix (the draft does not use the prefix as the name)
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, name prefix, revoke rules on delete, stateful, tags all, timeouts, vpc id.
# TODO: Re-create the rules beyond the known set of group module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix[0] (rules, module.retail_app_ecs.module.alb_sg.aws_security_group_rule.egress_rules) — an unknown number of entries of module.retail_app_ecs.module.alb_sg.aws_security_group_rule.egress_rules are not visible statically (group-choice): only the known ones were produced (phase BEFORE_PILOT, owner Security Architect)
# TODO: Re-create the rules beyond the known set of group module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix[0] (rules, module.retail_app_ecs.module.alb_sg.aws_security_group_rule.ingress_rules) — an unknown number of entries of module.retail_app_ecs.module.alb_sg.aws_security_group_rule.ingress_rules are not visible statically (group-choice): only the known ones were produced (phase BEFORE_PILOT, owner Security Architect)
# TODO: Place the source rule module.retail_app_ecs.module.alb_sg.aws_security_group_rule.egress_rules[0] on the security group it belongs to and write it — the rule is attached to module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix but cannot be attributed to one of its groups (group-choice); a rule on the wrong group allows what the source did not allow there, so none was produced (phase BEFORE_PILOT, owner Security Architect)
# TODO: Place the source rule module.retail_app_ecs.module.alb_sg.aws_security_group_rule.ingress_rules[0] on the security group it belongs to and write it — the rule is attached to module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix but cannot be attributed to one of its groups (group-choice); a rule on the wrong group allows what the source did not allow there, so none was produced (phase BEFORE_PILOT, owner Security Architect)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix rule module.retail_app_ecs.module.alb_sg.aws_security_group_rule.egress_rules[0] — rule withheld: no rule is produced: it cannot be attributed to a group (group-choice) (source: an allow rule of the unit's security group)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix rule module.retail_app_ecs.module.alb_sg.aws_security_group_rule.ingress_rules[0] — rule withheld: no rule is produced: it cannot be attributed to a group (group-choice) (source: an allow rule of the unit's security group)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix module.retail_app_ecs.module.alb_sg.aws_security_group_rule.egress_rules — rules beyond the known set: only the known entries are produced … the source allows more than the entries that are visible statically) (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix module.retail_app_ecs.module.alb_sg.aws_security_group_rule.ingress_rules — rules beyond the known set: only the known entries are produced … the source allows more than the entries that are visible statically) (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix): stackit_security_group.retail_app_ecs_alb_sg_this_name_prefix name — derived: name retail-app-ecs-alb-sg-this-name-prefix derived from the address … AWS names it from the name_prefix "retail-store-ecs-ui-" and a random suffix (the draft does not use the prefix as the name)) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHAN: not attached to the load balancer module.retail_app_ecs.module.alb.aws_lb.this … The client restriction of its rules on the load balancer is public on source, public on target: no access control is written.
# Lifecycle carried from module.retail_app_ecs.module.alb_sg.aws_security_group.this_name_prefix: create_before_destroy = true. These are Terraform meta-arguments: the same words hold for the STACKIT provider.
# trace: TR-70b29ec245ac (engineering/trace/security.md#TR-70b29ec245ac)
resource "stackit_security_group" "retail_app_ecs_alb_sg_this_name_prefix" {
  project_id  = var.project_id
  description = "UI ALB security group"
  labels      = var.sg_alb_sg_labels
  name        = "retail-app-ecs-alb-sg-this-name-prefix"
  lifecycle {
    create_before_destroy = true
  }
}

# from module.retail_app_ecs.module.alb.aws_security_group.this (.terraform/modules/retail_app_ecs.alb/main.tf:807) — RECONFIGURE / MEDIUM
# WARNING sg-egress-restricted: The source restricts egress (the AWS provider removes AWS's default allow-all egress rule; only the listed egress rules apply).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# name derived from the address of module.retail_app_ecs.module.alb.aws_security_group.this[0]: the source group has no name of its own: AWS names it from the name_prefix "retail-store-ecs-ui-" and a random suffix (the draft does not use the prefix as the name)
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, name prefix, revoke rules on delete, stateful, tags all, timeouts, vpc id.
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_security_group.this): stackit_security_group.retail_app_ecs_alb_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT project tested on … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.module.alb.aws_security_group.this): stackit_security_group.retail_app_ecs_alb_this name — derived: name retail-app-ecs-alb-this derived from the address module.retail_app_ecs.module.alb.aws_security_group.this[0] (source: the source group has no name of its own: AWS names it from the name_prefix "retail-store-ecs-ui-" and a random suffix (the draft does not use the prefix as the name))
# ORPHAN: not attached to the load balancer module.retail_app_ecs.module.alb.aws_lb.this … The client restriction of its rules on the load balancer is public on source, public on target: no access control is written.
# Lifecycle carried from module.retail_app_ecs.module.alb.aws_security_group.this: create_before_destroy = true. These are Terraform meta-arguments: the same words hold for the STACKIT provider.
# trace: TR-a59ae230c5b5 (engineering/trace/security.md#TR-a59ae230c5b5)
resource "stackit_security_group" "retail_app_ecs_alb_this" {
  project_id = var.project_id
  labels     = var.sg_alb_labels
  name       = "retail-app-ecs-alb-this"
  lifecycle {
    create_before_destroy = true
  }
}

# from module.retail_app_ecs.module.carts_service.aws_security_group.this (../../lib/ecs/service/sg.tf:1) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# the source's allow-all egress is covered by the STACKIT default egress rules; no rule is produced for it
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, labels, name prefix, revoke rules on delete, stateful, tags all, timeouts and 1 more.
# NOT CARRIED (module.retail_app_ecs.module.carts_service.aws_security_group.this): stackit_security_group.retail_app_ecs_carts_service_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT project … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHANED: drafted from module.retail_app_ecs.module.carts_service.aws_security_group.this; no block of the draft lists stackit_security_group.retail_app_ecs_carts_service_this (the cause is in the trace).
# The ECS tasks it protected become pods: NetworkPolicy decision DEC-GEN-CONVERT-POD-SEGMENTATION (alias `convert:module.retail_app_ecs.module.carts_service.aws_security_group.this:security-group:POD_SEGMENTATION`).
# SECURITY_OBSERVATION World-open ingress on an application port of module.retail_app_ecs.module.carts_service.aws_security_group.this, ingress tcp 8080-8080 from 0.0.0.0/0 (non-blocking): The source security group module.retail_app_ecs.module.carts_service.aws_security_group.this admits tcp 8080 from 0.0.0.0/0 (ingress[0]): any client on the internet can open a connection to that port of every resource the group is attached to. …
# trace: TR-5cd0f19b7ac7 (engineering/trace/security.md#TR-5cd0f19b7ac7)
resource "stackit_security_group" "retail_app_ecs_carts_service_this" {
  project_id = var.project_id
  name       = var.sg_carts_service_name
}

resource "stackit_security_group_rule" "retail_app_ecs_carts_service_this_ingress_1" {
  project_id        = var.project_id
  security_group_id = stackit_security_group.retail_app_ecs_carts_service_this.security_group_id
  direction         = "ingress"
  ether_type        = "IPv4"
  ip_range          = "0.0.0.0/0"
  port_range = {
    max = 8080
    min = 8080
  }
  protocol = {
    name = "tcp"
  }
}

# from module.retail_app_ecs.module.catalog_service.aws_security_group.this (../../lib/ecs/service/sg.tf:1) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# the source's allow-all egress is covered by the STACKIT default egress rules; no rule is produced for it
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, labels, name prefix, revoke rules on delete, stateful, tags all, timeouts and 1 more.
# NOT CARRIED (module.retail_app_ecs.module.catalog_service.aws_security_group.this): stackit_security_group.retail_app_ecs_catalog_service_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHANED: drafted from module.retail_app_ecs.module.catalog_service.aws_security_group.this; no block of the draft lists stackit_security_group.retail_app_ecs_catalog_service_this (the cause is in the trace).
# The ECS tasks it protected become pods: NetworkPolicy decision DEC-GEN-CONVERT-POD-SEGMENTATION (alias `convert:module.retail_app_ecs.module.catalog_service.aws_security_group.this:security-group:POD_SEGMENTATION`).
# SECURITY_OBSERVATION World-open ingress on an application port of module.retail_app_ecs.module.catalog_service.aws_security_group.this, ingress tcp 8080-8080 from 0.0.0.0/0 (non-blocking): The source security group module.retail_app_ecs.module.catalog_service.aws_security_group.this admits tcp 8080 from 0.0.0.0/0 (ingress[0]): any client on the internet can open a connection to that port of every resource the group is attached to. …
# trace: TR-66eb9edf4074 (engineering/trace/security.md#TR-66eb9edf4074)
resource "stackit_security_group" "retail_app_ecs_catalog_service_this" {
  project_id = var.project_id
  name       = var.sg_catalog_service_name
}

resource "stackit_security_group_rule" "retail_app_ecs_catalog_service_this_ingress_1" {
  project_id        = var.project_id
  security_group_id = stackit_security_group.retail_app_ecs_catalog_service_this.security_group_id
  direction         = "ingress"
  ether_type        = "IPv4"
  ip_range          = "0.0.0.0/0"
  port_range = {
    max = 8080
    min = 8080
  }
  protocol = {
    name = "tcp"
  }
}

# from module.retail_app_ecs.module.checkout_service.aws_security_group.this (../../lib/ecs/service/sg.tf:1) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# the source's allow-all egress is covered by the STACKIT default egress rules; no rule is produced for it
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, labels, name prefix, revoke rules on delete, stateful, tags all, timeouts and 1 more.
# NOT CARRIED (module.retail_app_ecs.module.checkout_service.aws_security_group.this): stackit_security_group.retail_app_ecs_checkout_service_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHANED: drafted from module.retail_app_ecs.module.checkout_service.aws_security_group.this; no block of the draft lists stackit_security_group.retail_app_ecs_checkout_service_this (the cause is in the trace).
# The ECS tasks it protected become pods: NetworkPolicy decision DEC-GEN-CONVERT-POD-SEGMENTATION (alias `convert:module.retail_app_ecs.module.checkout_service.aws_security_group.this:security-group:POD_SEGMENTATION`).
# SECURITY_OBSERVATION World-open ingress on an application port of module.retail_app_ecs.module.checkout_service.aws_security_group.this, ingress tcp 8080-8080 from 0.0.0.0/0 (non-blocking): The source security group module.retail_app_ecs.module.checkout_service.aws_security_group.this admits tcp 8080 from 0.0.0.0/0 (ingress[0]): any client on the internet can open a connection to that port of every resource the group is attached to. …
# trace: TR-e031d5a780d5 (engineering/trace/security.md#TR-e031d5a780d5)
resource "stackit_security_group" "retail_app_ecs_checkout_service_this" {
  project_id = var.project_id
  name       = var.sg_checkout_service_name
}

resource "stackit_security_group_rule" "retail_app_ecs_checkout_service_this_ingress_1" {
  project_id        = var.project_id
  security_group_id = stackit_security_group.retail_app_ecs_checkout_service_this.security_group_id
  direction         = "ingress"
  ether_type        = "IPv4"
  ip_range          = "0.0.0.0/0"
  port_range = {
    max = 8080
    min = 8080
  }
  protocol = {
    name = "tcp"
  }
}

# from module.retail_app_ecs.module.orders_service.aws_security_group.this (../../lib/ecs/service/sg.tf:1) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# the source's allow-all egress is covered by the STACKIT default egress rules; no rule is produced for it
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, labels, name prefix, revoke rules on delete, stateful, tags all, timeouts and 1 more.
# NOT CARRIED (module.retail_app_ecs.module.orders_service.aws_security_group.this): stackit_security_group.retail_app_ecs_orders_service_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHANED: drafted from module.retail_app_ecs.module.orders_service.aws_security_group.this; no block of the draft lists stackit_security_group.retail_app_ecs_orders_service_this (the cause is in the trace).
# The ECS tasks it protected become pods: NetworkPolicy decision DEC-GEN-CONVERT-POD-SEGMENTATION (alias `convert:module.retail_app_ecs.module.orders_service.aws_security_group.this:security-group:POD_SEGMENTATION`).
# SECURITY_OBSERVATION World-open ingress on an application port of module.retail_app_ecs.module.orders_service.aws_security_group.this, ingress tcp 8080-8080 from 0.0.0.0/0 (non-blocking): The source security group module.retail_app_ecs.module.orders_service.aws_security_group.this admits tcp 8080 from 0.0.0.0/0 (ingress[0]): any client on the internet can open a connection to that port of every resource the group is attached to. …
# trace: TR-382b1ee0a726 (engineering/trace/security.md#TR-382b1ee0a726)
resource "stackit_security_group" "retail_app_ecs_orders_service_this" {
  project_id = var.project_id
  name       = var.sg_orders_service_name
}

resource "stackit_security_group_rule" "retail_app_ecs_orders_service_this_ingress_1" {
  project_id        = var.project_id
  security_group_id = stackit_security_group.retail_app_ecs_orders_service_this.security_group_id
  direction         = "ingress"
  ether_type        = "IPv4"
  ip_range          = "0.0.0.0/0"
  port_range = {
    max = 8080
    min = 8080
  }
  protocol = {
    name = "tcp"
  }
}

# from module.retail_app_ecs.module.ui_service.aws_security_group.this (../../lib/ecs/service/sg.tf:1) — RECONFIGURE / MEDIUM
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# the source's allow-all egress is covered by the STACKIT default egress rules; no rule is produced for it
# NOTE: not written, the reason of each is in the trace: default egress.ipv4, default egress.ipv6, labels, name prefix, revoke rules on delete, stateful, tags all, timeouts and 1 more.
# NOT CARRIED (module.retail_app_ecs.module.ui_service.aws_security_group.this): stackit_security_group.retail_app_ecs_ui_service_this ingress — intra-group IPv6 traffic not established: IPv6 intra-group behaviour was not observed: an IPv6 network could not be created in the STACKIT project … the members of the group reach each other only where a rule of the group allows it) (shortened: the whole reason is in the trace of this block)
# LEDGER security group rules: security group rules → ORPHANED: no block of the draft attaches the group, so its rules restrict nothing on STACKIT — REVIEW
# ORPHANED: drafted from module.retail_app_ecs.module.ui_service.aws_security_group.this; no block of the draft lists stackit_security_group.retail_app_ecs_ui_service_this (the cause is in the trace).
# The ECS tasks it protected become pods: NetworkPolicy decision DEC-GEN-CONVERT-POD-SEGMENTATION (alias `convert:module.retail_app_ecs.module.ui_service.aws_security_group.this:security-group:POD_SEGMENTATION`).
# SECURITY_OBSERVATION World-open ingress on an application port of module.retail_app_ecs.module.ui_service.aws_security_group.this, ingress tcp 8080-8080 from 0.0.0.0/0 (non-blocking): The source security group module.retail_app_ecs.module.ui_service.aws_security_group.this admits tcp 8080 from 0.0.0.0/0 (ingress[0]): any client on the internet can open a connection to that port of every resource the group is attached to. …
# trace: TR-da82ede17870 (engineering/trace/security.md#TR-da82ede17870)
resource "stackit_security_group" "retail_app_ecs_ui_service_this" {
  project_id = var.project_id
  name       = var.sg_ui_service_name
}

resource "stackit_security_group_rule" "retail_app_ecs_ui_service_this_ingress_1" {
  project_id        = var.project_id
  security_group_id = stackit_security_group.retail_app_ecs_ui_service_this.security_group_id
  direction         = "ingress"
  ether_type        = "IPv4"
  ip_range          = "0.0.0.0/0"
  port_range = {
    max = 8080
    min = 8080
  }
  protocol = {
    name = "tcp"
  }
}

# from module.dependencies.aws_security_group.catalog_opensearch_sg (../../lib/dependencies/catalog_opensearch.tf:14) — RECONFIGURE / MEDIUM
# rule aws.security_group/sg · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# WARNING sg-egress-restricted: The source restricts egress (the AWS provider removes AWS's default allow-all egress rule; only the listed egress rules apply).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# NOT CARRIED (module.dependencies.aws_security_group.catalog_opensearch_sg): module.dependencies.aws_security_group.catalog_opensearch_sg — group not produced: no stackit_security_group and no rule is produced: every unit that names the group is a managed data service of STACKIT, and a STACKIT data service has no security group (the pinned provider schema has no attribute that names one) and takes its clients from an access list of its own: module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this (stackit_opensearch_instance, access list parameters.sgw_acl).
#   The group would be listed by no resource, so no stackit_security_group and no rule is drafted for it. What the group admitted reaches the access lists as addresses only, on the one endpoint port of the service: whether the clients of a rule are in the default of a list is stated on the block of the service (its DEFAULT line or its NOT CARRIED lines), and who may connect is the open decision EXPOSURE_WIDENED of the service; a rule whose clients no address names, or that reaches another port, is not carried.
#   The egress rules of the group are about the outbound traffic of the instance itself, which a managed data service exposes no filter for: they are not carried (source: an aws_security_group unit with 1 ingress, 0 egress and 0 other rules)

# from module.dependencies.aws_security_group.mq (../../lib/dependencies/mq.tf:33) — RECONFIGURE / MEDIUM
# rule aws.security_group/sg · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# WARNING sg-egress-restricted: The source restricts egress (the AWS provider removes AWS's default allow-all egress rule; only the listed egress rules apply).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# NOT CARRIED (module.dependencies.aws_security_group.mq): module.dependencies.aws_security_group.mq — group not produced: no stackit_security_group and no rule is produced: every unit that names the group is a managed data service of STACKIT, and a STACKIT data service has no security group (the pinned provider schema has no attribute that names one) and takes its clients from an access list of its own: module.dependencies.aws_mq_broker.mq (stackit_rabbitmq_instance, access list parameters.sgw_acl).
#   The group would be listed by no resource, so no stackit_security_group and no rule is drafted for it. What the group admitted reaches the access lists as addresses only, on the one endpoint port of the service: whether the clients of a rule are in the default of a list is stated on the block of the service (its DEFAULT line or its NOT CARRIED lines), and who may connect is the open decision EXPOSURE_WIDENED of the service; a rule whose clients no address names, or that reaches another port, is not carried.
#   The egress rules of the group are about the outbound traffic of the instance itself, which a managed data service exposes no filter for: they are not carried (source: an aws_security_group unit with 1 ingress, 0 egress and 0 other rules)

# from module.dependencies.module.catalog_rds.aws_security_group.this (.terraform/modules/dependencies.catalog_rds/main.tf:321) — RECONFIGURE / MEDIUM
# rule aws.security_group/sg · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# WARNING sg-egress-restricted: The source restricts egress (the AWS provider removes AWS's default allow-all egress rule; only the listed egress rules apply).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# NOT CARRIED (module.dependencies.module.catalog_rds.aws_security_group.this): module.dependencies.module.catalog_rds.aws_security_group.this — group not produced: no stackit_security_group and no rule is produced: every unit that names the group is a managed data service of STACKIT, and a STACKIT data service has no security group (the pinned provider schema has no attribute that names one) and takes its clients from an access list of its own: module.dependencies.module.catalog_rds.aws_rds_cluster.this (stackit_mariadb_instance, access list parameters.sgw_acl).
#   The group would be listed by no resource, so no stackit_security_group and no rule is drafted for it. What the group admitted reaches the access lists as addresses only, on the one endpoint port of the service: whether the clients of a rule are in the default of a list is stated on the block of the service (its DEFAULT line or its NOT CARRIED lines), and who may connect is the open decision EXPOSURE_WIDENED of the service; a rule whose clients no address names, or that reaches another port, is not carried.
#   The egress rules of the group are about the outbound traffic of the instance itself, which a managed data service exposes no filter for: they are not carried (source: an aws_security_group unit with 1 ingress, 0 egress and 0 other rules)

# from module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group.cbd (.terraform/modules/dependencies.checkout_elasticache_redis.aws_security_group/main.tf:81) — RECONFIGURE / MEDIUM
# rule aws.security_group/sg · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# NOT CARRIED (module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group.cbd): module.dependencies.module.checkout_elasticache_redis.module.aws_security_group.aws_security_group.cbd — group not produced: no stackit_security_group and no rule is produced: every unit that names the group is a managed data service of STACKIT,
#   and a STACKIT data service has no security group (the pinned provider schema has no attribute that names one) and takes its clients from an access list of its own: module.dependencies.module.checkout_elasticache_redis.aws_elasticache_replication_group.default (stackit_valkey_instance, access list parameters.sgw_acl). The group would be listed by no resource, so no stackit_security_group and no rule is drafted for it.
#   What the group admitted reaches the access lists as addresses only, on the one endpoint port of the service: whether the clients of a rule are in the default of a list is stated on the block of the service (its DEFAULT line or its NOT CARRIED lines), and who may connect is the open decision EXPOSURE_WIDENED of the service; a rule whose clients no address names, or that reaches another port, is not carried.
#   The egress rules of the group are about the outbound traffic of the instance itself, which a managed data service exposes no filter for: they are not carried (source: an aws_security_group unit with 1 ingress, 1 egress and 0 other rules)

# from module.dependencies.module.orders_rds.aws_security_group.this (.terraform/modules/dependencies.orders_rds/main.tf:321) — RECONFIGURE / MEDIUM
# rule aws.security_group/sg · KB 0.385.0 · target maturity GA · lifecycle active · mapping maturity beta · evidence internal · review required
# WARNING sg-egress-restricted: The source restricts egress (the AWS provider removes AWS's default allow-all egress rule; only the listed egress rules apply).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING sg-rule-not-rendered: At least one rule of this group is not in the draft as the source has it.
# NOT CARRIED (module.dependencies.module.orders_rds.aws_security_group.this): module.dependencies.module.orders_rds.aws_security_group.this — group not produced: no stackit_security_group and no rule is produced: every unit that names the group is a managed data service of STACKIT, and a STACKIT data service has no security group (the pinned provider schema has no attribute that names one) and takes its clients from an access list of its own: module.dependencies.module.orders_rds.aws_rds_cluster.this (stackit_postgresflex_instance, access list network.acl).
#   The group would be listed by no resource, so no stackit_security_group and no rule is drafted for it. What the group admitted reaches the access lists as addresses only, on the one endpoint port of the service: whether the clients of a rule are in the default of a list is stated on the block of the service (its DEFAULT line or its NOT CARRIED lines), and who may connect is the open decision EXPOSURE_WIDENED of the service; a rule whose clients no address names, or that reaches another port, is not carried.
#   The egress rules of the group are about the outbound traffic of the instance itself, which a managed data service exposes no filter for: they are not carried (source: an aws_security_group unit with 1 ingress, 0 egress and 0 other rules)

# One keyring for the migrated keys.
# trace: TR-af9e2a025af8 (engineering/trace/security.md#TR-af9e2a025af8)
resource "stackit_kms_keyring" "migrated" {
  project_id   = var.project_id
  display_name = "migrated-keys"
}

# from module.retail_app_ecs.aws_kms_key.cmk (../../lib/ecs/common.tf:1) — RECONFIGURE / MEDIUM
# access_scope is var.kms_access_scope, which has no default: without it the STACKIT API makes the key PUBLIC, a choice the source does not state. PUBLIC or SNA is yours.
# display_name made a name the STACKIT KMS API takes (1 to 64 characters of letters, digits, underscores and hyphens); source text: retail-store-ecs CMK
# No block of this draft uses this key, so nothing in the draft is encrypted with it: the resources of the source that reference it … AWS key material cannot be exported, so nothing is re-encrypted with this key either. …
# NOT CARRIED (module.retail_app_ecs.aws_kms_key.cmk): deletion_window_in_days = 7 — STACKIT KMS deletes a key scheduled for deletion after 30 days; stackit_kms_key has no deletion window (pinned provider).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# trace: TR-e47c9c2d3326 (engineering/trace/security.md#TR-e47c9c2d3326)
resource "stackit_kms_key" "retail_app_ecs_cmk" {
  project_id   = var.project_id
  keyring_id   = stackit_kms_keyring.migrated.keyring_id
  display_name = "retail-store-ecs-CMK"
  algorithm    = "aes_256_gcm"
  purpose      = "symmetric_encrypt_decrypt"
  protection   = var.kms_protection
  access_scope = var.kms_access_scope == "SNA" ? "SNA" : null
}

# One Secrets Manager instance holds all migrated secrets; recreate each secret as a key in it.
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.catalog_db): kms_key_id — the source encrypts with a customer-managed key that the draft does not set on the Secrets Manager instance: the instance also holds module.retail_app_ecs.aws_secretsmanager_secret.mq … The instance takes one STACKIT KMS key for all its secret values (kms_key); set it once the keys of the sources are decided. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.catalog_db): name — the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.catalog_db writes it into the Secrets Manager instance from a document you supply … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret_version.catalog_db): secret_id, secret_string — a setting of module.retail_app_ecs.aws_secretsmanager_secret.catalog_db: the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.catalog_db … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# CONSUMERS (module.retail_app_ecs.aws_secretsmanager_secret.catalog_db): module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this — each reads it today and is switched to a Vault client or a platform injection (External Secrets Operator on SKE; rule aws.secretsmanager_secret) …
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch): kms_key_id — the source encrypts with a customer-managed key that the draft does not set on the Secrets Manager instance: the instance also holds module.retail_app_ecs.aws_secretsmanager_secret.mq … The instance takes one STACKIT KMS key for all its secret values (kms_key); set it once the keys of the sources are decided. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch): name — the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch writes it into the Secrets Manager instance from a document you supply … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret_version.catalog_opensearch): secret_id, secret_string — a setting of module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch: the API step … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# CONSUMERS (module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch): module.retail_app_ecs.module.catalog_service.aws_ecs_task_definition.this — each reads it today and is switched to a Vault client or a platform injection …
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.mq): name — the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.mq writes it into the Secrets Manager instance from a document you supply … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret_version.mq): secret_id, secret_string — a setting of module.retail_app_ecs.aws_secretsmanager_secret.mq: the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.mq writes it into the Secrets … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# CONSUMERS (module.retail_app_ecs.aws_secretsmanager_secret.mq): module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this — each reads it today and is switched to a Vault client or a platform injection (External Secrets Operator on SKE; rule aws.secretsmanager_secret) …
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret.orders_db): name — the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.orders_db writes it into the Secrets Manager instance from a document you supply … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# NOT CARRIED (module.retail_app_ecs.aws_secretsmanager_secret_version.orders_db): secret_id, secret_string — a setting of module.retail_app_ecs.aws_secretsmanager_secret.orders_db: the API step API/secrets-manager-vault/WriteSecret/module.retail_app_ecs.aws_secretsmanager_secret.orders_db writes … none of its settings is generated as a resource. (shortened: the whole reason is in the trace of this block)
# CONSUMERS (module.retail_app_ecs.aws_secretsmanager_secret.orders_db): module.retail_app_ecs.module.orders_service.aws_ecs_task_definition.this — each reads it today and is switched to a Vault client or a platform injection (External Secrets Operator on SKE; rule aws.secretsmanager_secret) …
# module.retail_app_ecs.aws_secretsmanager_secret.catalog_db: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# module.retail_app_ecs.aws_secretsmanager_secret.mq: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# module.retail_app_ecs.aws_secretsmanager_secret.orders_db: WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# replaces: module.retail_app_ecs.aws_secretsmanager_secret.catalog_db, module.retail_app_ecs.aws_secretsmanager_secret.catalog_opensearch, module.retail_app_ecs.aws_secretsmanager_secret.mq, module.retail_app_ecs.aws_secretsmanager_secret.orders_db
# trace: TR-b77494749ed2 (engineering/trace/security.md#TR-b77494749ed2)
resource "stackit_secretsmanager_instance" "migrated_secrets" {
  project_id = var.project_id
  name       = "migrated-secrets"
}

# The user the API steps of the execution plan log in as to write the migrated secrets into the Secrets Manager instance.
# DEFAULT: write_enabled = true gives this user write access to the secrets engine of the whole instance (the provider schema: "If true, the user has writeaccess to the secrets engine"), so every secret of the instance, not one …
# trace: TR-6003c14a24b3 (engineering/trace/security.md#TR-6003c14a24b3)
resource "stackit_secretsmanager_user" "migration" {
  project_id    = var.project_id
  instance_id   = stackit_secretsmanager_instance.migrated_secrets.instance_id
  description   = "StackToIT migration user: writes the migrated secrets; delete it afterwards"
  write_enabled = true
}

# from module.retail_app_ecs.aws_secretsmanager_secret.catalog_db.
output "stackit_secretsmanager_instance_migrated_secrets_instance_id" {
  description = "The instance_id of stackit_secretsmanager_instance.migrated_secrets. An API step of the execution plan reads it (tofu output -raw stackit_secretsmanager_instance_migrated_secrets_instance_id) when its input variable is not set. Not sensitive: it is an identifier or a name, never a secret."
  value       = stackit_secretsmanager_instance.migrated_secrets.instance_id
}

# from module.retail_app_ecs.aws_secretsmanager_secret.catalog_db.
output "stackit_secretsmanager_user_migration_password" {
  description = "The password STACKIT generated for stackit_secretsmanager_user.migration. An API step of the execution plan that writes a migrated secret reads it (tofu output -json stackit_secretsmanager_user_migration_password) when its input variable is not set, and prints it nowhere. Sensitive: tofu output hides it from the plan, the state holds it in plain text; delete the user once the secrets are written."
  value       = stackit_secretsmanager_user.migration.password
  sensitive   = true
}

# from module.retail_app_ecs.aws_secretsmanager_secret.catalog_db.
output "stackit_secretsmanager_user_migration_username" {
  description = "The username of stackit_secretsmanager_user.migration. An API step of the execution plan reads it (tofu output -raw stackit_secretsmanager_user_migration_username) when its input variable is not set. Not sensitive: it is an identifier or a name, never a secret."
  value       = stackit_secretsmanager_user.migration.username
}
