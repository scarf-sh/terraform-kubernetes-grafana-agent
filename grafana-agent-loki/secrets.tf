resource "kubernetes_secret" "grafana_agent_loki" {
  metadata {
    name = "secret-grafana-agent-loki"
  }

  data = {
    LOKI_PASSWORD = var.loki_password
  }
}
