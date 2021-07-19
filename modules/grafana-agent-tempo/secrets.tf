resource "kubernetes_secret" "grafana_agent_traces" {
  metadata {
    name      = "secret-grafana-agent-traces"
    namespace = var.k8s_namespace
  }

  data = {
    TEMPO_PASSWORD = var.tempo_password
  }
}
