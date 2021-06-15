resource "kubernetes_secret" "grafana_agent" {
  metadata {
    name = "secret-grafana-agent"
  }

  data = {
    REMOTE_WRITE_PASSWORD = var.remote_write_password
  }
}
