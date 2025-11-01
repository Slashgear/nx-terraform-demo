terraform {
  required_version = ">= 1.0"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Scaleway Cockpit (Monitoring & Observability)
resource "scaleway_cockpit" "main" {
  project_id = var.project_id
}

resource "scaleway_cockpit_token" "main" {
  name = "${var.monitoring_name}-token"

  scopes {
    query_logs      = true
    write_logs      = true
    query_metrics   = true
    write_metrics   = true
    query_traces    = true
    write_traces    = true
  }
}

# Grafana Agent for K8s metrics collection
resource "kubernetes_namespace" "monitoring" {
  count = var.install_grafana_agent ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name        = var.namespace
      environment = var.environment
    }
  }
}

resource "kubernetes_secret" "cockpit_token" {
  count = var.install_grafana_agent ? 1 : 0

  metadata {
    name      = "cockpit-token"
    namespace = kubernetes_namespace.monitoring[0].metadata[0].name
  }

  data = {
    token = scaleway_cockpit_token.main.secret_key
  }

  type = "Opaque"
}

resource "helm_release" "grafana_agent" {
  count = var.install_grafana_agent ? 1 : 0

  name       = "grafana-agent"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana-agent"
  namespace  = kubernetes_namespace.monitoring[0].metadata[0].name
  version    = var.grafana_agent_version

  values = [
    templatefile("${path.module}/templates/grafana-agent-values.yaml.tpl", {
      cockpit_metrics_url = scaleway_cockpit.main.endpoints[0].metrics_url
      cockpit_logs_url    = scaleway_cockpit.main.endpoints[0].logs_url
      cockpit_traces_url  = scaleway_cockpit.main.endpoints[0].traces_url
    })
  ]

  set_sensitive {
    name  = "agent.config.server.log_level"
    value = var.log_level
  }
}
