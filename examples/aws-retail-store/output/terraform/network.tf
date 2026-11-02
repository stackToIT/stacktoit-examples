# Generated migration draft by StackToIT — architect review required. Not for apply without review.
# TOPOLOGY REVIEW (STACKIT_STABLE profile): the estate creates one VPC, module.vpc.module.vpc.aws_vpc.this, but
# module.dependencies.aws_mq_broker.mq, module.dependencies.module.catalog_opensearch.aws_opensearch_domain.this are placed in a
# subnet the scan cannot prove is a subnet of it (a literal id, a variable, a data source, an expression or a subnet the estate does
# not create), so a second VPC may share the draft's one project, var.project_id. The project is one VPC's boundary only if none
# does: confirm which VPC each of them is in, and whether the networks of another VPC belong in this project or in a project of
# their own joined through a Network Area.

# from module.vpc.module.vpc.aws_subnet.private (.terraform/modules/vpc.vpc/main.tf:267) — RECONFIGURE / MEDIUM
# DNS: the source uses the AWS VPC resolver, which answers internal EC2 host names (module.vpc.module.vpc.aws_vpc.this enable_dns_hostnames = true); ipv4_nameservers = var.default_ipv4_nameservers resolves public names only.
# Private DNS parity not established: STACKIT documents no private DNS zone or internal name resolution (STACKIT DNS serves public zones only; the DNS Resolver product is in beta); names only the VPC resolver answers need a DNS server of your own.
# TODO: PRIVATE_EGRESS_EQUIVALENCE_UNPROVEN — whether the source gives this subnet an IPv4 route to the internet is not proven (table-not-proven (selects-collapsed)); the network drafted here keeps STACKIT's default gateway with its outbound source NAT, and the draft leaves its routing and gateway settings at their platform defaults (the finding subnet-egress-ipv4-unproven names what would decide it).
# Behind the network ACL module.vpc.module.vpc.aws_default_network_acl.this (no STACKIT resource, so nothing here refuses what it refuses): not every rule of it could be read, so a deny rule may be among them (see module.vpc.module.vpc.aws_default_network_acl.this).
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.private): availability_zone, availability_zone_id — stackit_network has no availability zone (pinned provider): the network serves the region; servers and volumes choose their zone.
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.private): vpc_id — the source VPC is not generated: the network is created in the project (stackit_network also takes a vpc_id of the experimental STACKIT VPC feature, pinned provider — not used by this draft).
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.private): tags — the tags are not visible statically (a variable without a value, a computed value, a module output or an expression the scan cannot evaluate): no label is written for them. … keys and values of letters, digits, '-', '_' and '.'). (shortened: the whole reason is in the trace of this block)
# WARNING topology-vpc-unproven: The project can be taken as one VPC's boundary only if every resource that names a VPC provably names the estate's one, and this estate does not show it: the VPC this subnet names …
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING subnet-egress-ipv4-unproven: PRIVATE_EGRESS_EQUIVALENCE_UNPROVEN (IPv4, not proven).
# Drafted, consumers not placed: decision DEC-GEN-CONVERT-WORKLOAD-PLACEMENT (alias `convert:module.vpc.module.vpc.aws_subnet.private:network:WORKLOAD_PLACEMENT`); the step of this network waits for it (the consumers are in the trace).
# TODO: how many instances module.vpc.module.vpc.aws_subnet.private creates is not visible statically (its count/for_each is not known): count is var.vpc_vpc_private_count — set it to the real number and check each instance's settings.
# trace: TR-d39d5b78739a (engineering/trace/network.md#TR-d39d5b78739a)
resource "stackit_network" "vpc_vpc_private" {
  count            = var.vpc_vpc_private_count
  project_id       = var.project_id
  name             = "vpc-vpc-private-${count.index}"
  ipv4_prefix      = var.vpc_vpc_private_ipv4_prefixes[count.index]
  ipv4_nameservers = var.default_ipv4_nameservers
}

# from module.vpc.module.vpc.aws_subnet.public (.terraform/modules/vpc.vpc/main.tf:131) — RECONFIGURE / MEDIUM
# DNS: the source uses the AWS VPC resolver, which answers internal EC2 host names (module.vpc.module.vpc.aws_vpc.this enable_dns_hostnames = true); ipv4_nameservers = var.default_ipv4_nameservers resolves public names only.
# Private DNS parity not established: STACKIT documents no private DNS zone or internal name resolution (STACKIT DNS serves public zones only; the DNS Resolver product is in beta); names only the VPC resolver answers need a DNS server of your own.
# TODO: PRIVATE_EGRESS_EQUIVALENCE_UNPROVEN — whether the source gives this subnet an IPv4 route to the internet is not proven (the route table association module.vpc.module.vpc.aws_route_table_association.public names the subnet module.vpc.module.vpc.aws_subnet.public but the scan cannot show that it names every instance of it (a value that is not exactly one reference to it, an index that picks some instances, a count or for_each that is not the subnet's own), so which table it follows is not decided here);
#   the network drafted here keeps STACKIT's default gateway with its outbound source NAT, and the draft leaves its routing and gateway settings at their platform defaults (the finding subnet-egress-ipv4-unproven names what would decide it).
# Behind the network ACL module.vpc.module.vpc.aws_default_network_acl.this (no STACKIT resource, so nothing here refuses what it refuses): not every rule of it could be read, so a deny rule may be among them (see module.vpc.module.vpc.aws_default_network_acl.this).
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.public): availability_zone, availability_zone_id — stackit_network has no availability zone (pinned provider): the network serves the region; servers and volumes choose their zone.
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.public): vpc_id — the source VPC is not generated: the network is created in the project (stackit_network also takes a vpc_id of the experimental STACKIT VPC feature, pinned provider — not used by this draft).
# NOT CARRIED (module.vpc.module.vpc.aws_subnet.public): tags — the tags are not visible statically (a variable without a value, a computed value, a module output or an expression the scan cannot evaluate): no label is written for them. … keys and values of letters, digits, '-', '_' and '.'). (shortened: the whole reason is in the trace of this block)
# WARNING topology-vpc-unproven: The project can be taken as one VPC's boundary only if every resource that names a VPC provably names the estate's one, and this estate does not show it: the VPC this subnet names …
# WARNING subnet-route-table-undecided: The scan cannot say which route table this subnet follows: a route table association may name it through a value the scan cannot resolve (a variable, a literal ID, a conditional, a value from a module call) …
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# WARNING subnet-egress-ipv4-unproven: PRIVATE_EGRESS_EQUIVALENCE_UNPROVEN (IPv4, not proven).
# TODO: how many instances module.vpc.module.vpc.aws_subnet.public creates is not visible statically (its count/for_each is not known): count is var.vpc_vpc_public_count — set it to the real number and check each instance's settings.
# trace: TR-ca04594a2ad9 (engineering/trace/network.md#TR-ca04594a2ad9)
resource "stackit_network" "vpc_vpc_public" {
  count            = var.vpc_vpc_public_count
  project_id       = var.project_id
  name             = "vpc-vpc-public-${count.index}"
  ipv4_prefix      = var.vpc_vpc_public_ipv4_prefixes[count.index]
  ipv4_nameservers = var.default_ipv4_nameservers
}

# from module.vpc.module.vpc.aws_route_table.private (.terraform/modules/vpc.vpc/main.tf:296) — RECONFIGURE / LOW
# rule aws.route_table/rt-default-only-nat · KB 0.384.0 · mapping maturity beta · evidence internal · review required
# WARNING topology-route-table-not-drafted: This route table is created with count or for_each.
# WARNING topology-vpc-unproven: The project can be taken as one VPC's boundary only if every resource that names a VPC provably names the estate's one, and this estate does not show it: the VPC this route table names, or the VPC another resource of the estate names (a network ACL, a flow log, a peering connection, a Cloud Control subnet, ...), is a literal id, a variable, a data source, an attribute of a VPC other than its id (its arn, its owner id, ...) or an expression the scan cannot reduce to one reference to the VPC the estate creates (or the estate creates no VPC of its own).
# WARNING rt-private-subnet-association: A subnet uses a route table whose default route goes through a NAT gateway — a private subnet in AWS.
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# TODO: Create the target project outside a Network Area: module.vpc.module.vpc.aws_route_table.private is replaced by STACKIT's default routing, which was observed to give a routed network the same reachability only in a project outside a Network Area — STACKIT's default routing was observed to give a routed network the same reachability only in a project outside a Network Area (tested on a STACKIT project in eu01 on 2026-10-10);
#   the default routing table of an area was never read (the organisation read answered 403), so a project created inside an existing area (var.project_id naming one) is not covered by this replacement and the table needs the architect's decision there (phase BEFORE_PILOT, owner Network Architect)
# TODO: decision DEC-NET-STACKITROUTE-NAT-FIXED-EGRESS-ADDRESS-LOST (alias `stackitroute:module.vpc.module.vpc.aws_route_table.private:NAT_FIXED_EGRESS_ADDRESS_LOST`) — Decide the egress address of module.vpc.module.vpc.aws_route_table.private: keep the changing address of the STACKIT network, or give each server that an allow-list names a STACKIT public IP — a NAT gateway's fixed egress address is lost on STACKIT: the address a routed network leaves by is the network's own, shared by every routed network of the project, not fixed and not settable (phase BEFORE_PILOT)

# from module.vpc.module.vpc.aws_route_table.public (.terraform/modules/vpc.vpc/main.tf:164) — RECONFIGURE / MEDIUM
# rule aws.route_table/rt-default-only · KB 0.384.0 · mapping maturity beta · evidence internal · review required
# WARNING topology-route-table-not-drafted: This route table is created with count or for_each.
# WARNING topology-vpc-unproven: The project can be taken as one VPC's boundary only if every resource that names a VPC provably names the estate's one, and this estate does not show it: the VPC this route table names, or the VPC another resource of the estate names (a network ACL, a flow log, a peering connection, a Cloud Control subnet, ...), is a literal id, a variable, a data source, an attribute of a VPC other than its id (its arn, its owner id, ...) or an expression the scan cannot reduce to one reference to the VPC the estate creates (or the estate creates no VPC of its own).
# WARNING source-provider-unpinned: No lock file entry pins aws (>= 3.0, >= 3.29, >= 4.18, >= 4.30, >= 4.59, >= 5.64, >= 5.79, ~> 5.0): the version the plan would use is not proven (stated once for the whole estate)
# TODO: Create the target project outside a Network Area: module.vpc.module.vpc.aws_route_table.public is replaced by STACKIT's default routing, which was observed to give a routed network the same reachability only in a project outside a Network Area — STACKIT's default routing was observed to give a routed network the same reachability only in a project outside a Network Area (tested on a STACKIT project in eu01 on 2026-10-10);
#   the default routing table of an area was never read (the organisation read answered 403), so a project created inside an existing area (var.project_id naming one) is not covered by this replacement and the table needs the architect's decision there. Also not equivalent for a server WITHOUT a public IP: the source's internet gateway serves only an instance with a public IPv4 or Elastic IP address, so such a server had no internet path, while on STACKIT it leaves through the network's shared SNAT address (the test of 2026-10-10): that egress is new, the table does not carry it,
#   and it is decided on the subnet (subnet-egress-ipv4-unproven) (phase BEFORE_PILOT, owner Network Architect)
