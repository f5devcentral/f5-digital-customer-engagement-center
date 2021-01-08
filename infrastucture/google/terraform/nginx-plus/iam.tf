# nginx
resource "google_service_account" "gce-nginx-sa" {
  account_id   = "gce-nginx-sa"
  display_name = "nginx service account for secret access"
}
# add service account read permissions to secret
resource "google_secret_manager_secret_iam_member" "gce-nginx-sa-iam" {
  depends_on = [google_service_account.gce-nginx-sa]
  secret_id  = google_secret_manager_secret.nginx-secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.gce-nginx-sa.email}"
}
resource "google_project_iam_member" "project" {
  project = var.gcpProjectId
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.gce-nginx-sa.email}"
}
