# Prefer artifact registry over GCR because it allows more than one registry per
# project/location, ideal for shared projects like those at F5.
resource "google_artifact_registry_repository" "container" {
  provider      = google-beta
  count         = var.features.registry ? 1 : 0
  project       = var.gcpProjectId
  repository_id = format("%s-container-%s", var.projectPrefix, var.buildSuffix)
  description   = format("OCI registry for %s (%s)", var.projectPrefix, var.buildSuffix)
  format        = "DOCKER"
  location      = var.gcpRegion
  labels = merge(local.labels, {
    purpose = "containers"
  })
}
