# nginx
# create secret
resource "google_secret_manager_secret" "nginx-secret" {
  secret_id = "${var.prefix}-nginx-secret"
  labels = {
    label = "nginx"
  }

  replication {
    automatic = true
  }
}
# create secret version
resource "google_secret_manager_secret_version" "nginx-secret" {
  depends_on  = [google_secret_manager_secret.nginx-secret]
  secret      = google_secret_manager_secret.nginx-secret.id
  secret_data = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}",
  "cuser": "${var.controllerAccount}",
  "cpass": "${var.controllerPassword}"
  }
  EOF
}
