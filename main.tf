terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.5"
}

provider "aws" {
  alias = "management"
  # Use "aws configure" to create the "management" profile with the Management account credentials
  profile = "management"
}

provider "aws" {
  alias = "audit"
  # Use "aws configure" to create the "audit" profile with the Audit account credentials
  profile = "audit"
}

data "aws_caller_identity" "audit" {
  provider = aws.audit
}

resource "aws_organizations_delegated_administrator" "this" {
  provider          = aws.management
  account_id        = data.aws_caller_identity.audit.account_id
  service_principal = "access-analyzer.amazonaws.com"
}

resource "aws_accessanalyzer_analyzer" "org_external_access" {
  provider      = aws.audit
  analyzer_name = var.org_external_access_analyzer_name
  type          = "ORGANIZATION"
  depends_on    = [aws_organizations_delegated_administrator.this]
}

resource "aws_accessanalyzer_analyzer" "org_unused_access" {
  provider      = aws.audit
  count         = var.eanble_unused_access ? 1 : 0
  analyzer_name = var.org_unused_access_analyzer_name
  type          = "ORGANIZATION_UNUSED_ACCESS"
  configuration {
    unused_access {
      unused_access_age = var.unused_access_age
    }
  }
  depends_on = [aws_organizations_delegated_administrator.this]
}
