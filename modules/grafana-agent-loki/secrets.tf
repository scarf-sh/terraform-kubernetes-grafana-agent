resource "kubernetes_secret" "grafana_agent_loki" {
  metadata {
    name      = "secret-grafana-agent-loki"
    namespace = var.k8s_namespace
  }

  data = {
    LOKI_PASSWORD = var.loki_password
  }
}
