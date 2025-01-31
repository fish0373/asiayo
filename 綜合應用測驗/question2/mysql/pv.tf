resource "kubernetes_persistent_volume_claim" "mysql-primary-1" {
  metadata {
    name      = "mysql-primary-1"
    namespace = "asiayo"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    volume_mode  = "Filesystem"
    resources {
      requests = {
        "storage" = "2Gi"
      }
    }
    storage_class_name = "hostpath"
    selector {
      match_labels = {
        app = "mysql-primary-1"
      }
    }
  }
}

