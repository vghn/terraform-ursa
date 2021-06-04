terraform {
  backend "remote" {
    organization = "vgh"
    workspaces {
      name = "Ursa"
    }
  }
}

locals {
  # Budget
  max_monthly_spend = "1"
  currency          = "USD"

  # Tags
  common_tags = {
    Terraform = "true"
    Group     = "vgh"
    Project   = "ursa"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_budgets_budget" "max_monthly_spend" {
  name              = "Max Monthly AWS Spend"
  budget_type       = "COST"
  limit_amount      = local.max_monthly_spend
  limit_unit        = local.currency
  time_unit         = "MONTHLY"
  time_period_start = "2021-06-01_00:00"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "50"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.email]
  }
}

module "cloudwatch_event_watcher" {
  source = "github.com/vghn/terraform-cloudwatch_event_watcher"

  slack_alerts_hook_url = var.slack_alerts_hook_url
  common_tags           = var.common_tags
}

module "cloudtrail" {
  source = "github.com/vghn/terraform-cloudtrail"

  common_tags = var.common_tags
}
