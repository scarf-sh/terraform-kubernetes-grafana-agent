variable "loki_username" {
  type = string
}
variable "loki_password" {
  type = string
}
variable "loki_hostname" {
  type = string
}
variable "pipeline_stage" {
  type        = string
  default     = "docker"
  description = "Which pipeline_stage to use"
  # See https://grafana.com/docs/loki/latest/clients/promtail/configuration/#pipeline_stages for options
}
variable "k8s_namespace" {
  type        = string
  default     = "default"
  description = "Namespace to deploy grafana-agent-loki in"
}
