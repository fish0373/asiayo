
resource "kubernetes_stateful_set" "mysql-primary" {
  metadata {
    name      = "mysql-primary"
    namespace = "asiayo"
    labels = {
      app = "mysql-primary"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql-primary"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql-primary"
        }
      }

      spec {
        init_container {
          name  = "init-mysql"
          image = "mysql:8.4.4"
          command = [
            "bash",
            "-c",
            "/tmp/init/init-shell.sh",
          ]
          volume_mount {
            name       = "config-map"
            mount_path = "/tmp/init"
          }
          volume_mount {
            name       = "config"
            mount_path = "/etc/mysql/conf.d"
          }
        }
        container {
          image = "mysql:8.4.4"
          name  = "mysql-primary"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "!QAZ2wsx"
          }
          port {
            container_port = 3306
          }
          volume_mount {
            name       = "config-map"
            mount_path = "/tmp/init"
          }
          volume_mount {
            name       = "data"
            mount_path = "/var/lib/mysql"
          }
          volume_mount {
            name       = "config"
            mount_path = "/etc/mysql/conf.d"
          }
        }
        volume {
          name = "config-map"
          config_map {
            name = "mysql-primary"
            default_mode = "0755"
          }
        }
        volume {
          name = "config"
          empty_dir {}
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = "mysql-primary-1"
          }
        }
      }
    }
    service_name = "mysql-primary"
  }
}

resource "kubernetes_service" "mysql-primary" {
  metadata {
    name      = "mysql-primary"
    namespace = "asiayo"
    labels = {
      app = "mysql-primary"
    }
  }
  spec {
    port {
      name = "mysql"
      port = 3306
    }
    cluster_ip = "None"
    selector = {
      app = "mysql-primary"
    }
  }
}

resource "kubernetes_config_map" "mysql-primary" {
  metadata {
    name      = "mysql-primary"
    namespace = "asiayo"
    labels = {
      app = "mysql"
    }
  }
  data = {
    "my.cnf" = "[mysqld]"
    "init-shell.sh" = <<EOF
echo [mysqld] > /etc/mysql/conf.d/my.cnf
echo "bind-address=0.0.0.0" >> /etc/mysql/conf.d/my.cnf
echo server-id=999 >> /etc/mysql/conf.d/my.cnf
EOF
  }
}
