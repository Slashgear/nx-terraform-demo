# Scaleway Monitoring Module

This module creates a Scaleway Cockpit (Observability Stack) with optional Grafana Agent deployment for Kubernetes monitoring.

## Dependencies

This module requires:
- Kubernetes cluster (from the `scw-k8s` module) if installing Grafana Agent
- Scaleway project ID

## Features

- Scaleway Cockpit (managed Grafana, Prometheus, Loki, Tempo)
- Automatic metrics collection from Kubernetes
- Log aggregation
- Distributed tracing support
- Grafana Agent for data collection

## Usage

```hcl
module "monitoring" {
  source = "./modules/scw-monitoring"

  monitoring_name       = "my-app-monitoring"
  project_id            = var.scaleway_project_id
  install_grafana_agent = true
  namespace             = "monitoring"
  environment           = "production"
  retention_days        = 30

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
```

## Accessing Grafana

After deployment, you can access Grafana:

```bash
# Get Grafana URL
terraform output -module=monitoring grafana_url

# Login using your Scaleway credentials
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| monitoring_name | Name for monitoring resources | string | n/a | yes |
| project_id | Scaleway project ID | string | n/a | yes |
| install_grafana_agent | Install Grafana Agent for metrics collection | bool | true | no |
| namespace | Kubernetes namespace for monitoring stack | string | "monitoring" | no |
| environment | Environment label | string | "production" | no |
| grafana_agent_version | Version of Grafana Agent Helm chart | string | "0.40.0" | no |
| log_level | Log level for Grafana Agent | string | "info" | no |
| retention_days | Data retention in days | number | 30 | no |

## Outputs

| Name | Description |
|------|-------------|
| cockpit_id | ID of the Scaleway Cockpit |
| grafana_url | Grafana dashboard URL |
| metrics_url | Prometheus metrics endpoint URL |
| logs_url | Loki logs endpoint URL |
| traces_url | Tempo traces endpoint URL |
| token_id | ID of the Cockpit token |
| token_secret | Secret key for the Cockpit token (sensitive) |

## Architecture

```
┌─────────────────────────────────────┐
│     Kubernetes Cluster              │
│  ┌────────────────────────────────┐ │
│  │   Grafana Agent (DaemonSet)    │ │
│  │   - Scrapes metrics            │ │
│  │   - Collects logs              │ │
│  │   - Sends traces               │ │
│  └────────────────────────────────┘ │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   Scaleway Cockpit (Managed)        │
│  ┌────────────────────────────────┐ │
│  │   Prometheus (Metrics)         │ │
│  │   Loki (Logs)                  │ │
│  │   Tempo (Traces)               │ │
│  │   Grafana (Dashboards)         │ │
│  └────────────────────────────────┘ │
└─────────────────────────────────────┘
```
