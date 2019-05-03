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
      managed = "Terraform"
    }
  }
  spec {
    selector {
      app = "${kubernetes_pod.unstick.metadata.0.name}"
    }
    port {
      port        = 80
      target_port = 80
    }
    type       = "${var.service_type}"
    cluster_ip = "${var.service_cluster_ip}"
  }
}

resource "kubernetes_pod" "unstick" {
  metadata {
    name      = "unstick"
    namespace = "${var.namespace}"
    labels {
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
