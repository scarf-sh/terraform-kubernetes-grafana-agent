# grafana-agent-loki

This deploys grafana-agent for logs forwarding into the cluster.

Upstream refers to a shell script in
https://github.com/grafana/agent/#getting-started, which will essentially just
`envsubst` [a long manifests file](https://github.com/grafana/agent/blob/v0.12.0/production/kubernetes/agent-loki.yaml).

To properly track their lifecycle, they have been converted to terraform
resources, using `t2fs`.

## Example

```tf
module "grafana_agent_loki" {
  source = "github.com/scarf-sh/terraform-kubernetes-grafana-agent?ref=v0.1.1//grafana-agent-loki"

  loki_hostname = local.loki_hostname
  loki_username = local.loki_username
  loki_password = local.loki_password
}
```
