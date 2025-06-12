variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "public_subnets" {
  type = list(string)
}
variable "ec2_sg_ids" {
  type = list(string)
}
variable "target_group_arn" {}
variable "user_data" {
  type    = string
  default = ""
}