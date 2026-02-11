# infrastructure/main.tf

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Networking Module
module "networking" {
  source = "./modules/networking"
  
  project_name = var.project_name
}

# Compute Module
module "compute" {
  source = "./modules/compute"
  
  project_name      = var.project_name
  subnet_id         = module.networking.private_subnet_id
  security_group_id = module.networking.ec2_security_group_id
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load_balancer"
  
  project_name           = var.project_name
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  alb_security_group_id  = module.networking.alb_security_group_id
  instance_id            = module.compute.instance_id
}

# Frontend Module
module "frontend" {
  source = "./modules/frontend"
  
  project_name = var.project_name
  alb_dns_name = module.load_balancer.alb_dns_name
}