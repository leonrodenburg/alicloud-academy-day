data "alicloud_zones" "available" {}

# ----- Private layer ------

resource "alicloud_vswitch" "private-vswitches" {
  count = min(length(data.alicloud_zones.available), length(var.private_vswitches))

  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = data.alicloud_zones.available.zones[count.index].id
  cidr_block   = var.private_vswitches[count.index]
  vswitch_name = "private-${count.index + 1}"
}

output "private-vswitches" {
  value = alicloud_vswitch.private-vswitches
}

# ----- Data layer ------

resource "alicloud_vswitch" "data-vswitches" {
  count = min(length(data.alicloud_zones.available), length(var.data_vswitches))

  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = data.alicloud_zones.available.zones[count.index].id
  cidr_block   = var.data_vswitches[count.index]
  vswitch_name = "data-${count.index + 1}"
}

output "data-vswitches" {
  value = alicloud_vswitch.data-vswitches
}
