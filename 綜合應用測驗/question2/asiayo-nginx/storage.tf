resource "kubernetes_persistent_volume_v1" "asiayo-nginx-pv" {
  metadata {
    name = "asiayo-pv"
    labels = {
      app = "asiayo-nginx-pv"
    }
  }
  spec {
    capacity = {
      "storage" = "1Gi"
    }
    volume_mode                      = "Filesystem"
    access_modes                     = ["ReadOnlyMany"]
    persistent_volume_reclaim_policy = "Retain"
    persistent_volume_source {
      host_path {
        path = "/tmp/asiayo-nginx-pv"
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim_v1" "asiayo-nginx-pvc" {
  metadata {
    name      = "asiayo-nginx-pvc"
    namespace = "asiayo"
  }

  spec {
    access_modes = ["ReadOnlyMany"]
    volume_mode  = "Filesystem"
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
    selector {
      match_labels = {
        app = "asiayo-nginx-pv"
      }
    }
  }
}
