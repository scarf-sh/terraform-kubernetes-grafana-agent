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
