resource "alicloud_ram_role" "eci-container-group-role" {
  name        = "AliyunECIContainerGroupRole"
  description = "Role assumed by ECI container groups when creating / destroying resources"
  document    = <<EOF
    {
      "Version": "1",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": [
              "eci.aliyuncs.com"
            ]
          }
        }
      ]
    }
EOF
}

resource "alicloud_ram_role_policy_attachment" "eci-container-group-policy-attachment" {
  policy_name = "AliyunECIContainerGroupRolePolicy"
  policy_type = "System"
  role_name   = alicloud_ram_role.eci-container-group-role.name
}

