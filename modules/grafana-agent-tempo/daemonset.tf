resource "kubernetes_config_map" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace
  }

  data = {
    "agent.yaml" = templatefile("${path.module}/agent-daemonset.yaml", {
      TEMPO_USERNAME                  = var.tempo_username
      TEMPO_ENDPOINT                  = var.tempo_endpoint
      TEMPO_ATTRIBUTES                = var.tempo_attributes
      TEMPO_ENDPOINT_RETRY_ON_FAILURE = var.tempo_endpoint_retry_on_failure
      TEMPO_ENDPOINT_HEADERS          = var.tempo_endpoint_headers
      TEMPO_ADDITIONAL_ENDPOINTS      = var.tempo_additional_endpoints
    })
    "strategies.json" = "{\"default_strategy\": {\"param\": 0.001, \"type\": \"probabilistic\"}}"
  }
}

resource "kubernetes_daemonset" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace
  }

  spec {
    selector {
      match_labels = {
        name = "grafana-agent-traces"
      }
    }

    template {
      metadata {
        labels = {
          name = "grafana-agent-traces"
        }
      }

      spec {
        volume {
          name = "grafana-agent-traces"

          config_map {
            name = "grafana-agent-traces"
          }
        }

        # https://github.com/hashicorp/terraform-provider-kubernetes/issues/38
        automount_service_account_token = true
        service_account_name            = "grafana-agent"

        container {
          name    = "agent"
          image   = "grafana/agent:v0.17.0"
          command = ["/bin/agent"]
          args    = ["-config.file=/etc/agent/agent.yaml", "-config.expand-env"]

          port {
            name           = "http-metrics"
            container_port = 8080
          }

          port {
            name           = "thrift-compact"
            container_port = 6831
            protocol       = "UDP"
          }

          port {
            name           = "thrift-binary"
            container_port = 6832
            protocol       = "UDP"
          }

          port {
            name           = "thrift-http"
            container_port = 14268
            protocol       = "TCP"
          }

          port {
            name           = "thrift-grpc"
            container_port = 14250
            protocol       = "TCP"
          }

          port {
            name           = "zipkin"
            container_port = 9411
            protocol       = "TCP"
          }

          port {
            name           = "otlp"
            container_port = 55680
            protocol       = "TCP"
          }

          port {
            name           = "opencensus"
            container_port = 55678
            protocol       = "TCP"
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
            name = "TEMPO_PASSWORD"

            value_from {
              secret_key_ref {
                name = "secret-grafana-agent-traces"
                key  = "TEMPO_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "grafana-agent-traces"
            mount_path = "/etc/agent"
          }

          image_pull_policy = "IfNotPresent"
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
