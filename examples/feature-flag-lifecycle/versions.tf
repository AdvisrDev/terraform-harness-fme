terraform {
  required_version = ">= 1.5"
  
  required_providers {
    split = {
      source  = "davidji99/split"
      version = "~> 2.0"
    }
  }
}

provider "split" {
  api_key = var.split_api_key
}

variable "split_api_key" {
  description = "Split.io API key"
  type        = string
  sensitive   = true
}