resource "kubernetes_deployment" "grafana_agent" {
  metadata {
    name      = "grafana-agent"
    namespace = var.k8s_namespace
  }

  spec {
    min_ready_seconds = 10
    replicas = 1
    revision_history_limit = 10

    selector {
      match_labels = {
        name = "grafana-agent"
      }
    }

    template {
      metadata {
        labels = {
          name = "grafana-agent"
        }
      }

      spec {
        volume {
          name = "grafana-agent"

          config_map {
            name = "grafana-agent"
          }
        }

        # https://github.com/hashicorp/terraform-provider-kubernetes/issues/38
        automount_service_account_token = true
        service_account_name            = "grafana-agent"

        container {
          name    = "agent"
          image   = "grafana/agent:v0.17.0"
          command = ["/bin/agent"]
          args    = ["-config.file=/etc/agent/agent.yml", "-config.expand-env"]

          port {
            name           = "http-metrics"
            container_port = 12345
          }

          env {
            name = "HOSTNAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "REMOTE_WRITE_PASSWORD"

            value_from {
              secret_key_ref {
                name = "secret-grafana-agent"
                key  = "REMOTE_WRITE_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "grafana-agent"
            mount_path = "/etc/agent"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.grafana_agent,
    kubernetes_config_map.grafana_agent
  ]
}
