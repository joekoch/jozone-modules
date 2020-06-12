variable "subnetAid" {}
variable "subnetBid" {}
variable "subnetACIDR" {}
variable "subnetBCIDR" {}
variable "subnetCid" {}
variable "subnetDid" {}
variable "subnetCCIDR" {}
variable "subnetDCIDR" {}
variable "vpc_id" {}
variable "accessip" {
}
variable "key_name" {}
variable "instance_name" {}
variable "cloudwatch_retention" {
  default = 30
}
variable "cloudwatch_loggroup_name" {}
variable "sub_volume_size" {}
variable "root_volume_size" {}
variable "project_name" {}
variable "pvt_key" {}


variable "environment" {}
variable "region" {}
variable "app" {}
variable "init_script" {}
variable "app_function" {}
variable "l_conf_ec2_count" {}
variable "ami" {}
variable "ec2_instance_type" {}
variable "fromport" {}
variable "toport" {}
variable "spot_price" {}
variable "asg_count" {}
variable "asg_min_size" {}
variable "asg_des_size" {}
variable "asg_max_size" {}