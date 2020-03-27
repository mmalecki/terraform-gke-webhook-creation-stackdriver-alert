resource "google_logging_metric" "webhook_creation" {
  name = "WebhookCreation"

  filter = <<EOF
resource.type="k8s_cluster"
resource.labels.cluster_name="${var.cluster_name}"
resource.labels.location="${var.cluster_location}"
protoPayload.request.kind="ValidatingWebhookConfiguration" OR protoPayload.request.kind="MutatingWebhookConfiguration"
EOF

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"

    labels {
      key = "name"
      value_type = "STRING"
    }
  }

  label_extractors = {
    "name" = "EXTRACT(protoPayload.request.metadata.name)"
  }
}

resource "google_monitoring_alert_policy" "webhook_creation" {
  display_name = var.display_name
  combiner     = "OR"

  conditions {
    display_name = var.display_name

    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.webhook_creation.name}\" resource.type=\"k8s_cluster\""
      duration   = "0s"
      comparison = "COMPARISON_GT"

      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_SUM"
        per_series_aligner   = "ALIGN_SUM"

        group_by_fields = ["metric.label.name"]
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels
}
