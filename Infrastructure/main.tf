terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.invoice_bucket_name
  s3_bucket_name = var.picture_bucket_name
  environment    = var.environment
}

module "iam" {
  source = "./modules/iam"
  bucket_arn = module.s3.bucket_arn
}

module "lambda" {
  source           = "./modules/lambda"
  bucket_name      = var.invoice_bucket_name
  sender_email     = var.sender_email
  lambda_role_arn  = module.iam.lambda_role_arn
}

module "eventbridge" {
  source          = "./modules/eventbridge"
  lambda_arn      = module.lambda.lambda_function_arn
  lambda_name     = module.lambda.lambda_function_name
}

module "network" {
  source     = "./modules/network"
  aws_region = var.aws_region
}

module "security" {
  source   = "./modules/security"
  vpc_id   = module.network.vpc_id
  security_group_ids = [module.security.alb_sg_id]
}

module "ec2" {
  source                 = "./modules/ec2"
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [module.security.ec2_sg_id]
  iam_instance_profile   = module.iam.ec2_profile_name
  key_name               = var.key_name
}

module "rds" {
  source             = "./modules/rds"
  rds_instance_class = var.rds_instance_class
  rds_username       = var.rds_username
  rds_password       = var.rds_password
  subnet_ids         = [module.network.private_a_id, module.network.private_b_id]
  ec2_sg_id          = module.security.ec2_sg_id
  vpc_id             = module.network.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.network.vpc_id
  public_subnets = [module.network.public_subnet_id]
  alb_sg_id      = module.security.alb_sg_id
}

module "asg" {
  source               = "./modules/asg"
  ami_id               = "ami-0b74f796d330ab49c"
  instance_type        = "t2.micro"
  key_name             = var.key_name
  iam_instance_profile = module.iam.ec2_profile_name
  public_subnets       = [module.network.public_subnet_id]
  ec2_sg_ids           = [module.security.ec2_sg_id]
  target_group_arn     = module.alb.target_group_arn
  user_data            = file("${path.module}/scripts/user_data.sh")
}