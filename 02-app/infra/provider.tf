terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.121.2"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.1.0"
    }
  }
}

provider "kubernetes" {
  config_path = "kube.config"
}
