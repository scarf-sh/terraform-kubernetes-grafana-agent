resource "kubernetes_daemonset" "node_exporter" {
  metadata {
    name      = "node-exporter"
    namespace = var.k8s_namespace_node_exporter

    labels = {
      name = "node-exporter"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "node-exporter"
      }
    }

    template {
      metadata {
        labels = {
          name = "node-exporter"
        }
      }

      spec {
        volume {
          name = "sys"

          host_path {
            path = "/sys"
          }
        }

        volume {
          name = "root"

          host_path {
            path = "/"
          }
        }

        container {
          name  = "node-exporter"
          image = "quay.io/prometheus/node-exporter:v1.0.1"
          args  = ["--web.listen-address=0.0.0.0:9100", "--path.sysfs=/host/sys", "--path.rootfs=/host/root", "--no-collector.wifi", "--no-collector.hwmon", "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)"]

          port {
            container_port = 9100
            host_port      = 9100
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "180Mi"
            }

            requests = {
              cpu    = "102m"
              memory = "180Mi"
            }
          }

          volume_mount {
            name              = "sys"
            read_only         = true
            mount_path        = "/host/sys"
            mount_propagation = "HostToContainer"
          }

          volume_mount {
            name              = "root"
            read_only         = true
            mount_path        = "/host/root"
            mount_propagation = "HostToContainer"
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        host_network = true
        host_pid     = true

        security_context {
          run_as_user     = 65534
          run_as_non_root = true
        }

        toleration {
          operator = "Exists"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "10%"
      }
    }
  }
}

