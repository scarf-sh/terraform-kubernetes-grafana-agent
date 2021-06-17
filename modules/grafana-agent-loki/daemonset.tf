resource "kubernetes_config_map" "grafana_agent_logs" {
  metadata {
    name      = "grafana-agent-logs"
    namespace = var.k8s_namespace
  }

  data = {
    "agent.yaml" = templatefile("${path.module}/agent-daemonset.yaml", {
      LOKI_USERNAME = var.loki_username
      LOKI_HOSTNAME = var.loki_hostname
    })
  }
}

resource "kubernetes_daemonset" "grafana_agent_logs" {
  metadata {
    name      = "grafana-agent-logs"
    namespace = var.k8s_namespace
  }

  spec {
    selector {
      match_labels = {
        name = "grafana-agent-logs"
      }
    }

    template {
      metadata {
        labels = {
          name = "grafana-agent-logs"
        }
      }

      spec {
        volume {
          name = "grafana-agent-logs"

          config_map {
            name = "grafana-agent-logs"
          }
        }

        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "etcmachineid"

          host_path {
            path = "/etc/machine-id"
          }
        }

        # https://github.com/hashicorp/terraform-provider-kubernetes/issues/38
        automount_service_account_token = true
        service_account_name            = "grafana-agent"

        container {
          name    = "agent"
          image   = "grafana/agent:main-c7ac289"
          command = ["/bin/agent"]
          args    = ["-config.file=/etc/agent/agent.yaml", "-config.expand-env"]

          port {
            name           = "http-metrics"
            container_port = 8080
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
            name = "LOKI_PASSWORD"

            value_from {
              secret_key_ref {
                name = "secret-grafana-agent-loki"
                key  = "LOKI_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "grafana-agent-logs"
            mount_path = "/etc/agent"
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }

          volume_mount {
            name       = "etcmachineid"
            read_only  = true
            mount_path = "/etc/machine-id"
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
}
