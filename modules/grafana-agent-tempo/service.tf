resource "kubernetes_service" "grafana_agent_traces" {
  metadata {
    name      = "grafana-agent-traces"
    namespace = var.k8s_namespace

    labels = {
      name = "grafana-agent-traces"
    }
  }

  spec {
    port {
      name        = "agent-http-metrics"
      port        = 8080
      target_port = "8080"
    }

    port {
      name        = "agent-thrift-compact"
      protocol    = "UDP"
      port        = 6831
      target_port = "6831"
    }

    port {
      name        = "agent-thrift-binary"
      protocol    = "UDP"
      port        = 6832
      target_port = "6832"
    }

    port {
      name        = "agent-thrift-http"
      protocol    = "TCP"
      port        = 14268
      target_port = "14268"
    }

    port {
      name        = "agent-thrift-grpc"
      protocol    = "TCP"
      port        = 14250
      target_port = "14250"
    }

    port {
      name        = "agent-zipkin"
      protocol    = "TCP"
      port        = 9411
      target_port = "9411"
    }

    port {
      name        = "agent-otlp"
      protocol    = "TCP"
      port        = 55680
      target_port = "55680"
    }

    port {
      name        = "agent-opencensus"
      protocol    = "TCP"
      port        = 55678
      target_port = "55678"
    }

    selector = {
      name = "grafana-agent-traces"
    }
  }
}

