resource "kubernetes_deployment" "asiayo-nginx" {
  metadata {
    name      = "asiayo-nginx"
    namespace = "asiayo"
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "asiayo-nginx"
      }
    }

    template {
      metadata {
        name = "asiayo-nginx"
        labels = {
          app = "asiayo-nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
          volume_mount {
            name       = "web-files"
            mount_path = "/mnt/http/"
          }
        }
        volume {
          name = "web-files"
          persistent_volume_claim {
            claim_name = "asiayo-nginx-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "asiayo-service" {
  metadata {
    name      = "asiayo-service"
    namespace = "asiayo"
    labels = {
      app = "asiayo-service"
    }
  }
  spec {
    port {
      name = "http"
      port = 80
    }
    cluster_ip = "None"
    selector = {
      app = "asiayo-nginx"
    }
  }
}
