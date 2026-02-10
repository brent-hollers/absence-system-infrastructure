terraform {
  backend "s3" {
    bucket         = "hollers-absence-tfstate-005608856189"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "absence-system-terraform-locks"
    encrypt        = true
  }
}