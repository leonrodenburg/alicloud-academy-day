variable "image" {}
variable "region" {}
variable "access_key_id" {
  sensitive = true
}
variable "access_key_secret" {
  sensitive = true
}

resource "kubernetes_secret" "academy-app-secret" {
  metadata {
    name = "academy-day-secret"
  }

  data = {
    accessKeyId = var.access_key_id
    accessKeySecret = var.access_key_secret
  }
}

resource "kubernetes_deployment" "academy-app-deployment" {
  metadata {
    name      = "academy-day-app"
    namespace = "default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "academy-day-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "academy-day-app"
        }
      }
      spec {
        container {
          name              = "app"
          image             = var.image
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }

          env {
            name  = "TABLE_STORE_ENDPOINT"
            value = "https://${data.alicloud_ots_instances.instances.names[0]}.${var.region}.ots.aliyuncs.com"
          }
          env {
            name  = "TABLE_STORE_INSTANCE"
            value = data.alicloud_ots_instances.instances.names[0]
          }
          env {
            name  = "TABLE_STORE_TABLE"
            value = alicloud_ots_table.table.table_name
          }
          env {
            name  = "TABLE_STORE_ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.academy-app-secret.metadata[0].name
                key = "accessKeyId"
              }
            }
          }
          env {
            name  = "TABLE_STORE_ACCESS_KEY_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.academy-app-secret.metadata[0].name
                key = "accessKeySecret"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "academy-app-service" {
  metadata {
    name        = "academy-day-app"
    annotations = {
      "service.beta.kubernetes.io/alibaba-cloud-loadbalancer-spec" = "slb.s1.small"
    }
  }
  spec {
    type = "LoadBalancer"

    selector = {
      app = "academy-day-app"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080
    }
  }
}
