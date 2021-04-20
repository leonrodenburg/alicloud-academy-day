module "vpc" {
  source = "./modules/vpc"

  vpc = {
    cidr = "10.0.0.0/8"
  }

  nat = {
    deploy        = true
    specification = "Small"

    eip = {
      bandwidth = 200
    }
  }

  private_vswitches = [
    "10.11.0.0/16",
    "10.12.0.0/16",
  ]

  data_vswitches = [
    "10.21.0.0/16",
    "10.22.0.0/16",
  ]

  security_group = {
    rules = [
      {
        type        = "egress"
        ip_protocol = "tcp"
        port_range  = "1/65535"
        cidr_ip     = "0.0.0.0/0"
      }
    ]
  }
}

module "serverless-k8s-cluster" {
  source = "./modules/k8s/cluster"

  vpc_id      = module.vpc.vpc.id
  vswitch_ids = module.vpc.private-vswitches.*.id
  create_nat  = false

  create_private_zone = true
  expose_api          = true
}
