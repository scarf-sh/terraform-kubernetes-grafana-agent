resource "kubernetes_secret" "grafana_agent" {
  metadata {
    name      = "secret-grafana-agent"
    namespace = var.k8s_namespace
  }

  data = {
    REMOTE_WRITE_PASSWORD = var.remote_write_password
  }
}
