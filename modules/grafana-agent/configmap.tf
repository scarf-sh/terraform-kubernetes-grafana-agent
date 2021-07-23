resource "kubernetes_config_map" "grafana_agent" {
  metadata {
    name      = "grafana-agent"
    namespace = var.k8s_namespace
  }
  data = {
    "agent.yml" = templatefile("${path.module}/agent.yaml", {
      REMOTE_WRITE_URL             = var.remote_write_url
      REMOTE_WRITE_USERNAME        = var.remote_write_username
      EXTERNAL_LABELS              = var.external_labels
    })
  }
}

