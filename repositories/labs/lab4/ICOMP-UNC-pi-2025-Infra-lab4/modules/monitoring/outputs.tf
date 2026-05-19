output "grafana_service_name" {
  description = "Grafana Kubernetes service name."
  value       = "kube-prometheus-stack-grafana"
}

output "prometheus_service_name" {
  description = "Prometheus Kubernetes service name."
  value       = "kube-prometheus-stack-prometheus"
}

output "namespace" {
  description = "Namespace where the monitoring stack is deployed."
  value       = var.namespace
}
