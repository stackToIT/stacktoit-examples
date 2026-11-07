# Generated migration draft by StackToIT — architect review required. Not for apply without review.

# One SKE cluster runs the migrated container workloads (Cloud Run jobs and Cloud Run services) as Deployments, Jobs and CronJobs … If the draft already has an SKE cluster, the architect may run them there and drop this one. (full text: engineering/trace/kubernetes.md)
# google_cloud_run_v2_job.migrate: WARNING run-unsupported-volume: A container mounts a Cloud SQL connection, a Cloud Storage bucket (through Cloud Storage FUSE) or an NFS share.
# google_cloud_run_v2_job.migrate: WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# DEFAULT: the zones of the node pool are var.availability_zones, ["eu01-1", "eu01-2", "eu01-3"] unless you set it (3 zones, every zone of the region the catalogue lists): the Google Cloud resources on this cluster state no zone to carry, so the draft spreads the pool over all of them. An SKE node pool's maximum must be at least the number of its zones (var.containers_nodes_max is checked against it): list fewer zones if the workloads need fewer nodes.
# from google_cloud_run_v2_job.migrate: its Kubernetes manifests are kubernetes/migrate/manifests.yaml (the required inputs, secrets to create and NOT CARRIED lines are in its header).
# google_cloud_run_v2_service.server: WARNING run-unsupported-volume: A container mounts a Cloud SQL connection, a Cloud Storage bucket (through Cloud Storage FUSE) or an NFS share.
# google_cloud_run_v2_service.server: WARNING run-iam-policy: A full IAM policy (member/role bindings) is set directly on the service via policy_data; STACKIT has no per-service IAM policy resource, so who may invoke the migrated SKE workload is decided by a person — the draft carries no invocation check.
# google_cloud_run_v2_service.server: WARNING source-provider-unverified: no lock file records the version of registry.terraform.io/hashicorp/google, and the constraint ">= 6, < 8" excludes it (pinned 8.4.0) (stated once for the whole estate)
# from google_cloud_run_v2_service.server: its Kubernetes manifests are kubernetes/server/manifests.yaml (the required inputs, secrets to create and NOT CARRIED lines are in its header).
# Lifecycle of google_cloud_run_v2_service.server not written to this block: ignore_changes = [scaling] names source attributes the draft does not hold under the same meaning (or by a part of them): state ignore_changes on the attribute that holds the value if the target is to leave it alone too.
# replaces: google_cloud_run_v2_job.migrate, google_cloud_run_v2_service.server
# trace: TR-d30d8f964263 (engineering/trace/kubernetes.md#TR-d30d8f964263)
resource "stackit_ske_cluster" "containers" {
  project_id = var.project_id
  name       = "containers"
  node_pools = [{
    name               = "workloads"
    machine_type       = var.containers_machine_type
    minimum            = var.containers_nodes_min
    maximum            = var.containers_nodes_max
    availability_zones = var.availability_zones
  }]
}

output "containers_name" {
  description = "The name of the SKE cluster stackit_ske_cluster.containers. `stackit ske kubeconfig create <name> --project-id <project-id> --filepath <file> --expiration 1h -y` takes it to fetch the kubeconfig that the Kubernetes manifests of this draft are applied with. Not sensitive."
  value       = stackit_ske_cluster.containers.name
}
