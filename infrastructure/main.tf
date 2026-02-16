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
  n8n_domain        = var.domain_name
  enable_https      = var.enable_https
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load_balancer"
  
  project_name           = var.project_name
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  alb_security_group_id  = module.networking.alb_security_group_id
  instance_id            = module.compute.instance_id
  enable_https           = var.enable_https
  certificate_arn        = var.enable_https ? module.dns[0].certificate_arn : ""
}

# Frontend Module
module "frontend" {
  source = "./modules/frontend"
  
  project_name = var.project_name
  alb_dns_name = module.load_balancer.alb_dns_name
}

# DNS Module - references existing certificate
module "dns" {
  count  = var.enable_https ? 1 : 0
  source = "./modules/dns"
  
  domain_name = var.domain_name
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"
  
  project_name                 = var.project_name
  aws_region                   = var.aws_region
  instance_id                  = module.compute.instance_id
  alb_arn                      = module.load_balancer.alb_arn
  alb_arn_suffix               = module.load_balancer.alb_arn_suffix
  target_group_arn             = module.load_balancer.target_group_arn
  target_group_arn_suffix      = module.load_balancer.target_group_arn_suffix
  cloudfront_distribution_id   = module.frontend.cloudfront_distribution_id
  alert_email                  = var.alert_email
}