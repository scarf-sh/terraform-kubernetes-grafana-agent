# grafana-agent

This deploys grafana-agent for metrics collection into the cluster.

Upstream refers to a shell script in
https://github.com/grafana/agent/#getting-started, which will essentially just
`envsubst` [a long manifests file](https://github.com/grafana/agent/blob/v0.12.0/production/kubernetes/agent.yaml).

To properly track their lifecycle, they have been converted to terraform
resources, using `t2fs`.
