resource "alicloud_cs_serverless_kubernetes" "cluster" {
  depends_on = [
    alicloud_ram_role_policy_attachment.eci-container-group-policy-attachment
  ]

  vpc_id                         = var.vpc_id
  vswitch_ids                    = var.vswitch_ids
  new_nat_gateway                = var.create_nat
  private_zone                   = var.create_private_zone
  endpoint_public_access_enabled = var.expose_api
}

output "cluster" {
  value = alicloud_cs_serverless_kubernetes.cluster
}
