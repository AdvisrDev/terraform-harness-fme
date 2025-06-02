terraform {
  required_version = ">= 1.5"

  required_providers {
    split = {
      source = "davidji99/split"
    }
  }

  backend "http" {
    address        = "https://app.harness.io/gateway/iacm/api/orgs/sandbox/projects/CristianRamirez/workspaces/Payment_Service_Split_Feature_Flags/terraform-backend?accountIdentifier=EeRjnXTnS4GrLG5VNNJZUw"
    username       = "harness"
    lock_address   = "https://app.harness.io/gateway/iacm/api/orgs/sandbox/projects/CristianRamirez/workspaces/Payment_Service_Split_Feature_Flags/terraform-backend/lock?accountIdentifier=EeRjnXTnS4GrLG5VNNJZUw"
    lock_method    = "POST"
    unlock_address = "https://app.harness.io/gateway/iacm/api/orgs/sandbox/projects/CristianRamirez/workspaces/Payment_Service_Split_Feature_Flags/terraform-backend/lock?accountIdentifier=EeRjnXTnS4GrLG5VNNJZUw"
    unlock_method  = "DELETE"
  }
}
