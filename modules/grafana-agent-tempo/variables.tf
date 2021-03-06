variable "tempo_endpoint" {
  type = string
}
variable "tempo_endpoint_headers" {
  type        = map(any)
  default     = {}
  description = "Additional headers to send for the default endpoint, if any."
}
variable "tempo_endpoint_retry_on_failure" {
  type        = bool
  default     = false
  description = "Whether to enable 'Retry on failure' for the default endpoint."
}
variable "tempo_endpoint_protocol" {
  type        = string
  default     = "grpc"
  description = "The protocol to use when sending to the (first) endpoint. grpc/http."
}
variable "tempo_username" {
  type        = string
  description = "Username to use for basic auth. Set to empty string to disable basic auth."
}
variable "tempo_password" {
  type = string
}
variable "tempo_additional_endpoints" {
  type        = list(any)
  default     = []
  description = "Additional endpoints to configure"
}
variable "tempo_attributes" {
  type        = map(any)
  default     = {}
  description = "Attributes to set for all endpoints."
}
variable "k8s_namespace" {
  type        = string
  default     = "default"
  description = "Namespace to deploy grafana-agent-loki in"
}
