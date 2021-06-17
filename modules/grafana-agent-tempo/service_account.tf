resource "kubernetes_service_account" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace
  }
}

resource "kubernetes_cluster_role" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace
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

resource "kubernetes_cluster_role_binding" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace
  }

  subject {
    kind      = "ServiceAccount"
    name      = "grafana-agent-traces"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "grafana-agent-traces"
  }
}

