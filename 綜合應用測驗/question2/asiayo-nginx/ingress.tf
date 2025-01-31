resource "kubernetes_ingress_v1" "asiayo-ingress" {

  metadata {
    name      = "asiayo-ingress"
    namespace = "asiayo"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" : "/"
    }
  }
  spec {
    rule {
      host = "asiayo.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "asiayo-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
