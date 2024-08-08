data "aws_eks_cluster" "example" {
  name = var.default_suffix
}

data "aws_eks_cluster_auth" "example" {
  name = var.default_suffix
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.example.token
  }
}

resource "helm_release" "gitlab_runner" {
  name       = "gitlab-runner"
  repository = "https://charts.gitlab.io"
  chart      = "gitlab-runner"
  namespace  = "gitlab-runners"
  version    = "0.67.1"

  values = [
    <<EOF
    gitlabUrl: https://gitlab.rootdemo.eficode.io
    runnerRegistrationToken: ${var.gitlab_runner_registration_token}
    runners:
      concurrent: ${var.idle_runner_pool_size}
      executor: kubernetes
      kubernetes:
        pod_annotations:
          job-lifecycle: ephemeral
      namespace: ${var.gitlab_runner_namespace  }
      poll_interval: ${var.poll_new_job_interval}
      privileged: false
      tags: 
        - "eks"
        - "AL2_x86_64"
    EOF
  ]
}

resource "kubernetes_namespace" "gitlab_runners" {
  metadata {
    name = var.gitlab_runner_namespace
  }
}

resource "kubernetes_secret" "gitlab_runner_token" {
  metadata {
    name      = "gitlab-runner-token"
    namespace = kubernetes_namespace.gitlab_runners.metadata[0].name
  }
  data = {
    runner-registration-token = var.gitlab_runner_registration_token
  }
}

resource "kubernetes_deployment" "gitlab_runner_pool" {
  metadata {
    name      = "gitlab-runner-pool"
    namespace = kubernetes_namespace.gitlab_runners.metadata[0].name
  }
  spec {
    replicas = var.idle_runner_pool_size

    selector {
      match_labels = {
        app = "gitlab-runner-pool"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitlab-runner-pool"
        }
      }

      spec {
        container {
          name  = "gitlab-runner"
          image = "gitlab/gitlab-runner:latest"

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          env {
            name  = "CI_SERVER_URL"
            value = "https://gitlab.rootdemo.eficode.io"
          }

          env {
            name = "RUNNER_REGISTRATION_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.gitlab_runner_token.metadata[0].name
                key  = "runner-registration-token"
              }
            }
          }

          env {
            name  = "RUNNER_EXECUTOR"
            value = "kubernetes"
          }

          env {
            name  = "KUBERNETES_NAMESPACE"
            value = kubernetes_namespace.gitlab_runners.metadata[0].name
          }
        }
      }
    }
  }
}