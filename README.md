# `terraform-gke-webhook-creation-stackdriver-alert`

`terraform-gke-webhook-creation-stackdriver-alert` is a Terraform module that
creates a Stackdriver logging-based metric and alerting policy that triggers
when either a `ValidatingWebhookConfiguration` or `MutatingWebhookConfiguration`
are created in your GKE cluster.

The idea for this module came from the talk
[Advanced Persistence Threats: The Future of Kubernetes Attacks](https://www.rsaconference.com/usa/agenda/advanced-persistence-threats-the-future-of-kubernetes-attacks-3).

**Note**: the Stackdriver alert will automatically resolve after the time series
no longer violates the treshold of 0 creations. That means that unless the cluster
is seeing continuous creation of webhooks, the alert triggered by this module
will expire very quickly (2 - 5 minutes, in my testing). Therefore, it is
recommended that the alerts are sent to a notification channel that's non-ephemeral
and auditable, for example a Slack channel dedicated to security alerts.


## Example Usage
```hcl
module "webhook_creation" {
  source                = "git::https://github.com/mmalecki/terraform-gke-webhook-creation-stackdriver-alert.git"
  display_name          = "Validating or mutating webhook creation"
  cluster_name          = "my-cluster-01"
  cluster_location      = "europe-west4"
  notification_channels = [
    "projects/my-project-deadbeef/notificationChannels/133713371337",
  ]
}
```

## Argument Reference

The following arguments are supported:

* `display_name` - the display name for the alert policy
* `cluster_name` - the cluster to observe
* `cluster_location` - the cluster location to observe
* `notification_channels` - array of notification channel self-links to notify
  if the alerting policy gets triggered
