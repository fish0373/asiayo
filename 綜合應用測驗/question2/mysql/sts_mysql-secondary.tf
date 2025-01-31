
resource "kubernetes_stateful_set" "mysql-secondary" {
  metadata {
    name      = "mysql-secondary"
    namespace = "asiayo"
    labels = {
      app = "mysql-secondary"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "mysql-secondary"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql-secondary"
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
          name  = "mysql-secondary"
          command = [
            "/bin/bash",
            "-c",
            <<EOF
docker-entrypoint.sh mysqld & 
until mysqladmin ping -h 127.0.0.1 --silent; do
  sleep 2
done
mysql -uroot -p!QAZ2wsx -h 127.0.0.1 -e "
STOP REPLICA;
RESET REPLICA ALL;
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='mysql-primary-0.mysql-primary',
  SOURCE_USER='root',
  SOURCE_PASSWORD='!QAZ2wsx';
START REPLICA;"
wait
EOF
          ] 
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
            name         = "mysql-secondary"
            default_mode = "0755"
          }
        }
        volume {
          name = "config"
          empty_dir {}
        }
      }
    }
    service_name = "mysql-secondary"
    volume_claim_template {
      metadata {
        name = "data"
      }
      spec {
        storage_class_name = "hostpath"
        access_modes       = ["ReadWriteOnce"]
        volume_mode        = "Filesystem"
        resources {
          requests = {
            "storage" = "2Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql-secondary" {
  metadata {
    name      = "mysql-secondary"
    namespace = "asiayo"
    labels = {
      app = "mysql-secondary"
    }
  }
  spec {
    port {
      name = "mysql"
      port = 3306
    }
    cluster_ip = "None"
    selector = {
      app = "mysql-secondary"
    }
  }
}

resource "kubernetes_config_map" "mysql-secondary" {
  metadata {
    name      = "mysql-secondary"
    namespace = "asiayo"
    labels = {
      app = "mysql"
    }
  }
  data = {
    "my.cnf"        = "[mysqld]"
    "init-shell.sh" = <<EOF
echo [mysqld] > /etc/mysql/conf.d/my.cnf
echo "server-id=10$${HOSTNAME//[!0-9]/}" >> /etc/mysql/conf.d/my.cnf
echo "read-only=on" >> /etc/mysql/conf.d/my.cnf
EOF
  }
}
