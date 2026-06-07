# =============================================================================
# PROVIDER VERSIONS AND REQUIREMENTS
# =============================================================================
# This file specifies the Terraform version requirements and provider 
# configurations for the centralized alert management infrastructure.
# These version constraints ensure compatibility and stable deployments.
# =============================================================================

terraform {
  # Terraform version requirement
  required_version = ">= 1.0"

  # Required providers with version constraints
  required_providers {
    # AWS Provider - Primary cloud provider for all resources
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
    # Random Provider - For generating unique resource identifiers
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Terraform Cloud/Enterprise configuration (optional)
  # Uncomment and configure if using Terraform Cloud or Enterprise
  # cloud {
  #   organization = "your-organization"
  #   workspaces {
  #     name = "centralized-alert-management"
  #   }
  # }

  # Backend configuration for state management
  # Uncomment and configure for remote state storage
  # backend "s3" {
  #   bucket  = "your-terraform-state-bucket"
  #   key     = "centralized-alert-management/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  #   
  #   # DynamoDB table for state locking
  #   dynamodb_table = "terraform-state-locks"
  # }
}

# =============================================================================
# AWS PROVIDER CONFIGURATION
# =============================================================================

provider "aws" {
  # AWS region will be determined by:
  # 1. Environment variable AWS_DEFAULT_REGION
  # 2. AWS CLI configuration profile
  # 3. EC2 instance metadata (if running on EC2)
  
  # Default tags applied to all AWS resources
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = "Centralized Alert Management"
      Repository  = "aws-recipes/centralized-alert-management-notifications"
      CreatedBy   = "Infrastructure as Code"
    }
  }

  # Assume role configuration (optional)
  # Uncomment if deploying via assume role
  # assume_role {
  #   role_arn = "arn:aws:iam::ACCOUNT-ID:role/TerraformExecutionRole"
  # }
}

# =============================================================================
# RANDOM PROVIDER CONFIGURATION
# =============================================================================

provider "random" {
  # No specific configuration needed for random provider
  # Used for generating unique suffixes for resource names
}

