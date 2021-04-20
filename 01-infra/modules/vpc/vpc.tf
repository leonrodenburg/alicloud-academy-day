resource "alicloud_vpc" "vpc" {
  cidr_block  = var.vpc.cidr
}

output "vpc" {
  value = alicloud_vpc.vpc
}