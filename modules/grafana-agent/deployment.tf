resource "kubernetes_config_map" "grafana_agent_deployment" {
  metadata {
    name = "grafana-agent-deployment"
  }
  data = {
    "agent.yml" = templatefile("${path.module}/agent-deployment.yaml", {
      REMOTE_WRITE_URL      = var.remote_write_url
      REMOTE_WRITE_USERNAME = var.remote_write_username
      EXTERNAL_LABELS       = var.external_labels
    })
  }
}

resource "kubernetes_deployment" "grafana_agent_deployment" {
  metadata {
    name = "grafana-agent-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "grafana-agent-deployment"
      }
    }

    template {
      metadata {
        labels = {
          name = "grafana-agent-deployment"
        }
      }

      spec {
        volume {
          name = "grafana-agent-deployment"

          config_map {
            name = "grafana-agent-deployment"
          }
        }

        automount_service_account_token = true
        service_account_name            = "grafana-agent"


        container {
          name    = "agent"
          image   = "grafana/agent:v0.16.0"
          command = ["/bin/agent"]
          args    = ["-config.file=/etc/agent/agent.yml", "-config.expand-env", "-prometheus.wal-directory=/tmp/agent/data"]

          port {
            name           = "http-metrics"
            container_port = 80
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
            name       = "grafana-agent-deployment"
            mount_path = "/etc/agent"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }
        }
      }
    }

    min_ready_seconds      = 10
    revision_history_limit = 10
  }

  depends_on = [
    kubernetes_secret.grafana_agent,
    kubernetes_config_map.grafana_agent_deployment
  ]
}
