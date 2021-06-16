# grafana-agent

This deploys grafana-agent for metrics collection into the cluster.

Upstream refers to a shell script in
https://github.com/grafana/agent/#getting-started, which will essentially just
`envsubst` [a long manifests file](https://github.com/grafana/agent/blob/v0.12.0/production/kubernetes/agent.yaml).

To properly track their lifecycle, they have been converted to terraform
resources, using `t2fs`.

## Example

```tf
module "grafana_agent" {
  source = "github.com/scarf-sh/terraform-kubernetes-grafana-agent?ref=v0.1.1//grafana-agent"

  remote_write_url      = local.prometheus_remote_write_url
  remote_write_username = local.prometheus_remote_write_username
  remote_write_password = local.prometheus_remote_write_password
  external_labels = {
    region = local.prometheus_remote_write_region
  }
}
```
