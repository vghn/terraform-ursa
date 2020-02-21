variable "email" {
  description = "Notifications email"
  type        = string
}

variable "slack_alerts_hook_url" {
  description = "Slack Alerts Channel Hook URL"
  type        = string
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = map(string)
  default     = {}
}
