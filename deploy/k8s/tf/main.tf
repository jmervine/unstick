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
      app = "unstick"
    }
    port {
      port        = 80
      target_port = 80
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
            value = "80"
          }
          env {
            name  = "BIND"
            value = "0.0.0.0"
          }
        }
      }
    }
  }
}
