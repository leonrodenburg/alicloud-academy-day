resource "alicloud_nat_gateway" "nat-gateway" {
  count = var.nat.deploy ? 1 : 0

  vpc_id        = alicloud_vpc.vpc.id
  vswitch_id    = alicloud_vswitch.private-vswitches[0].id
  specification = var.nat.specification
  nat_type      = "Enhanced"
}

resource "alicloud_eip" "nat-eip" {
  count     = var.nat.deploy ? 1 : 0
  bandwidth = var.nat.eip.bandwidth
}

resource "alicloud_eip_association" "nat-eip-association" {
  count = var.nat.deploy ? 1 : 0

  allocation_id = alicloud_eip.nat-eip[count.index].id
  instance_id   = alicloud_nat_gateway.nat-gateway[count.index].id
}

resource "alicloud_snat_entry" "nat-snat-entry" {
  depends_on = [
    alicloud_eip_association.nat-eip-association
  ]

  count = var.nat.deploy ? length(alicloud_vswitch.private-vswitches) : 0

  snat_ip           = alicloud_eip.nat-eip[0].ip_address
  snat_table_id     = alicloud_nat_gateway.nat-gateway[0].snat_table_ids
  source_vswitch_id = alicloud_vswitch.private-vswitches[count.index].id
}

output "nat-gateway" {
  value = var.nat.deploy ? alicloud_nat_gateway.nat-gateway[0] : null
}

output "snat-eip" {
  value = var.nat.deploy ? alicloud_eip.nat-eip[0] : null
}
