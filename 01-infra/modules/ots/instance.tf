resource "alicloud_ots_instance" "instance" {
  name          = var.instance_name
  accessed_by   = "Any"
  instance_type = "Capacity"
}
