terraform {
  required_version = ">= 0.12"
  backend "remote" {
    organization = "vgh"
    workspaces {
      name = "Ursa"
    }
  }
}

locals {
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

module "notifications" {
  source = "github.com/vghn/terraform-notifications"
  email  = var.email

  common_tags = var.common_tags
}

module "billing" {
  source = "github.com/vghn/terraform-billing"

  notifications_topic_arn = module.notifications.topic_arn
  thresholds              = ["1", "2", "3", "4", "5"]
  account                 = "Ursa"

  common_tags = var.common_tags
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
