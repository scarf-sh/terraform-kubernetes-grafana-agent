# terraform-kubernetes-grafana-agent

This repository contains 3 Terraform Modules, deploying `grafana-agent`.

It is heavily inspired by what the `sh -c $(curl …) | kubectl apply -f -`
scripts at https://github.com/grafana/agent#getting-started produce, but
exposes certain configuration parameters as module variables.

The initial migration was done via the `ks2tf` tool, but for keeping up to date
with upstream changes, it's probably best to diff their configuration changes
across different releases.
