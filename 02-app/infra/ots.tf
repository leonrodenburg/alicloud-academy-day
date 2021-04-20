variable "ots_table_name" {
  type    = string
  default = "academyday"
}

data "alicloud_ots_instances" "instances" {}

resource "alicloud_ots_table" "table" {
  instance_name = data.alicloud_ots_instances.instances.names[0]
  table_name    = var.ots_table_name

  primary_key {
    name = "id"
    type = "String"
  }

  time_to_live                  = -1
  max_version                   = 1
  deviation_cell_version_in_sec = 1
}
