provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
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
      privileged: true
      tags: 
        - "eks"
        - "AL2_x86_64"
    EOF
  ]
}
