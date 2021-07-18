resource "kubernetes_service_account" "grafana_agent_logs" {
  metadata {
    name      = "grafana-agent-logs"
    namespace = var.k8s_namespace
  }
}

resource "kubernetes_cluster_role" "grafana_agent_logs" {
  metadata {
    name = "grafana-agent-logs"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  }

  rule {
    verbs             = ["get"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "grafana_agent_logs" {
  metadata {
    name = "grafana-agent-logs"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "grafana-agent-logs"
    namespace = var.k8s_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "grafana-agent-logs"
  }
}

