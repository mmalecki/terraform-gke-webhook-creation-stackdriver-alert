variable "display_name" {
  type        = string
  description = "The display name for the alert policy"
}

variable "cluster_name" {
  type        = string
  description = "The cluster to observe"
}

variable "cluster_location" {
  type        = string
  description = "The cluster location to observe"
}

variable "notification_channels" {
  type        = list(string)
  description = "Array of notification channel self-links to notify if the alerting policy gets triggered"
}
