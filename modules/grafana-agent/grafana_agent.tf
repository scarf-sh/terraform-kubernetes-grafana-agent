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
variable "k8s_namespace_kube_state_metrics" {
  type        = string
  default     = "default"
  description = "Namespace that kube-state-metrics is deployed in"
}
