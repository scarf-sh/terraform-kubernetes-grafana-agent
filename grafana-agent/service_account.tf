resource "kubernetes_service_account" "grafana_agent" {
  metadata {
    name = "grafana-agent"
  }
}

resource "kubernetes_cluster_role" "grafana_agent" {
  metadata {
    name = "grafana-agent"
  }

  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "nodes/proxy",
      "services",
      "endpoints",
      "pods"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "grafana_agent" {
  metadata {
    name = "grafana-agent"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "grafana-agent"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "grafana-agent"
    namespace = "default"
  }
}
