# terraform-kubernetes-grafana-agent

This repository contains 3 Terraform Modules, deploying `grafana-agent`.

It is heavily inspired by what the `sh -c $(curl …) | kubectl apply -f -`
scripts at https://github.com/grafana/agent#getting-started produce, but
exposes certain configuration parameters as module variables.

The initial migration was done via the `ks2tf` tool, but for keeping up to date
with upstream changes, it's probably best to diff their configuration changes
across different releases.

This project is built and maintained in Scarf's collaboration with
[Numtide](https://numtide.com).

## Usage

See each individual folders:

* [grafana-agent](./modules/grafana-agent) - to forward metrics
* [grafana-agent-loki](./modules/grafana-agent-loki) - to forward logs
* [grafana-agent-tempo](./modules/grafana-agent-tempo) - to forward traces

# License

(c) 2021 Scarf Systems, Inc.
