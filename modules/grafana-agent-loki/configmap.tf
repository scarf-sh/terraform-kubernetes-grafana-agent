resource "kubernetes_config_map" "grafana_agent_logs" {
  metadata {
    name      = "grafana-agent-logs"
    namespace = var.k8s_namespace
  }

  data = {
    "agent.yaml" = templatefile("${path.module}/agent.yaml", {
      LOKI_USERNAME  = var.loki_username
      LOKI_HOSTNAME  = var.loki_hostname
      pipeline_stage = var.pipeline_stage
    })
  }
}

