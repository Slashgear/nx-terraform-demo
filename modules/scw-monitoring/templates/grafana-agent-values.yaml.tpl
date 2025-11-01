agent:
  mode: flow
  configMap:
    content: |
      // Scrape Kubernetes metrics
      prometheus.scrape "kubernetes" {
        targets = discovery.kubernetes.pods.targets
        forward_to = [prometheus.remote_write.cockpit.receiver]
      }

      // Remote write to Scaleway Cockpit
      prometheus.remote_write "cockpit" {
        endpoint {
          url = "${cockpit_metrics_url}"
          bearer_token_file = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        }
      }

      // Collect logs
      loki.source.kubernetes "pods" {
        targets    = discovery.kubernetes.pods.targets
        forward_to = [loki.write.cockpit.receiver]
      }

      // Remote write logs to Cockpit
      loki.write "cockpit" {
        endpoint {
          url = "${cockpit_logs_url}"
          bearer_token_file = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        }
      }

serviceAccount:
  create: true

rbac:
  create: true
