resource "kubernetes_namespace" "gitlab_runners" {
  metadata {
    name = "gitlab-runners"
  }
}