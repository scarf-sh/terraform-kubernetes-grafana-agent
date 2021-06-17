variable "loki_username" {
  type = string
}
variable "loki_password" {
  type = string
}
variable "loki_hostname" {
  type = string
}
variable "k8s_namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes namespace to use"
}