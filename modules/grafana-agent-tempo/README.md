# grafana-agent-tempo

This deploys grafana-agent for traces forwarding into the cluster.

Upstream refers to a shell script in
https://github.com/grafana/agent/#getting-started, which will essentially just
`envsubst` [a long manifests file](https://github.com/grafana/agent/blob/v0.16.0/production/kubernetes/agent-tempo.yaml).

To properly track their lifecycle, they have been converted to terraform
resources, using `t2fs`.

## Example

```tf
module "grafana_agent_tempo" {
  source = "github.com/scarf-sh/terraform-kubernetes-grafana-agent?ref=v0.1.1//grafana-agent-tempo"

  tempo_endpoint = local.tempo_endpoint
  tempo_username = local.tempo_username
  tempo_password = local.tempo_password
  tempo_attributes = {
    actions = [{
      key    = "region",
      action = "insert",
      value  = local.tempo_region,
    }]
  }
  tempo_additional_endpoints = [{
    endpoint = "api.honeycomb.io:443"
    headers = {
      x-honeycomb-team    = local.honeycomb_team
      x-honeycomb-dataset = local.honeycomb_dataset
    }
    retry_on_failure = {
      enabled = true
    }
  }]
}
```
