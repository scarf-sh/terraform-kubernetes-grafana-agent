resource "kubernetes_secret" "grafana_agent_traces" {
  metadata {
    name = "secret-grafana-agent-traces"
  }

  data = {
    TEMPO_PASSWORD = var.tempo_password
  }
}
