provider "kubernetes" { }

resource "kubernetes_namespace" "unstick" {
  count = "${var.make_namespace}"
  metadata {
    name = "${var.namespace}"
  }
}

resource "kubernetes_service" "unstick" {
  metadata {
    name      = "unstick"
    namespace = "${var.namespace}"
    labels {
      app     = "unstick"
      managed = "Terraform"
    }
  }
  spec {
    selector {
      app = "${kubernetes_deployment.unstick.metadata.0.labels.app}"
    }
    port {
      port        = "${var.port}"
      target_port = "${var.port}"
    }
    type       = "${var.service_type}"
    cluster_ip = "${var.service_cluster_ip}"
  }
}

resource "kubernetes_deployment" "unstick" {
  metadata {
    name      = "unstick"
    namespace = "${var.namespace}"
    labels {
      app     = "unstick"
      managed = "Terraform"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "unstick"
      }
    }

    template {
      metadata {
        labels {
          app     = "unstick"
          managed = "Terraform"
        }
      }

      spec {
        container {
          image = "jmervine/unstick:${var.version}"
          name  = "unstick"
          env {
            name  = "COOKIE_NAME"
            value = "${var.cookie_name}"
          }
          env {
            name  = "REDIRECT"
            value = "${var.redirect}"
          }
          env {
            name  = "PORT"
            value = "${var.port}"
          }
          env {
            name  = "BIND"
            value = "${var.bind}"
          }
        }
      }
    }
  }
}
