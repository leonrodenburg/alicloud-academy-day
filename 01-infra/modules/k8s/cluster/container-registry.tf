resource "alicloud_cr_namespace" "namespace" {
  name               = var.registry_namespace_name
  auto_create        = true
  default_visibility = "PRIVATE"
}
