# This is only used for registry.terraform.io to detect the sub-modules.
module "grafana-agent" {
  source = "./grafana-agent"
}

module "grafana-agent-loki" {
  source = "./grafana-agent-loki"
}

module "grafana-agent-tempo" {
  source = "./grafana-agent-tempo"
}
