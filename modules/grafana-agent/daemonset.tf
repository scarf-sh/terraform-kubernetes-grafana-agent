resource "kubernetes_config_map" "grafana_agent_daemonset" {
  metadata {
    name = "grafana-agent"
  }
  data = {
    "agent.yml" = templatefile("${path.module}/agent-daemonset.yaml", {
      REMOTE_WRITE_URL      = var.remote_write_url
      REMOTE_WRITE_USERNAME = var.remote_write_username
      NAMESPACE             = "default"
      EXTERNAL_LABELS       = var.external_labels
    })
  }
}

resource "kubernetes_daemonset" "grafana_agent_daemonset" {
  metadata {
    name = "grafana-agent"
  }

  spec {
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
          image   = "grafana/agent:v0.15.0"
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
            name       = "grafana-agent"
            mount_path = "/etc/agent"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }
        }

        toleration {
          operator = "Exists"
          effect   = "NoSchedule"
        }
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    min_ready_seconds = 10
  }

  depends_on = [
    kubernetes_secret.grafana_agent,
    kubernetes_config_map.grafana_agent_daemonset
  ]
}
