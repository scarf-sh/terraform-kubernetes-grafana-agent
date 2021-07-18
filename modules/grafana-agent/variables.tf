variable "remote_write_url" {
  type = string
}
variable "remote_write_username" {
  type = string
}
variable "remote_write_password" {
  type = string
}
variable "external_labels" {
  type    = map(string)
  default = {}
}
variable "k8s_namespace" {
  type        = string
  default     = "default"
  description = "Namespace to deploy grafana-agent in"
}
variable "k8s_namespace_kube_state_metrics" {
  type        = string
  default     = "default"
  description = "Namespace that kube-state-metrics is deployed in"
}
variable "k8s_namespace_node_exporter" {
  type        = string
  default     = "default"
  description = "Namespace that node-exporter should be deployed in"
}
