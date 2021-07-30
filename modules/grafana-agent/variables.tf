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
