terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.14.1"
    }
  }
  

}

data "aws_eks_cluster" "example" {
  name = var.default_suffix
}

data "aws_eks_cluster_auth" "example" {
  name = var.default_suffix
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    host                   = data.aws_eks_cluster.example.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.example.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

resource "kubernetes_namespace" "opa" {
  metadata {
    name = "opa"
  }
}

resource "helm_release" "opa" {
  name       = "opa"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart      = "gatekeeper"
  namespace  = kubernetes_namespace.opa.metadata[0].name
  version    = "3.16.3"
}

#
# REQUIRE K8S LABEL
#
resource "kubectl_manifest" "opa_k8sRequiredLabel_tpl" {
  yaml_body = file("${path.module}/manifests/k8sRequiredLabel.tpl.yml")
  depends_on = [helm_release.opa]
}

resource "kubectl_manifest" "opa_k8sRequiredLabel" {
  yaml_body = file("${path.module}//manifests/k8sRequiredLabel.yml")
  depends_on = [helm_release.opa]
}

#
# REQUIRE UNPRIVILEDGED PODS
#
resource "kubectl_manifest" "opa_unpriviledged_tpl" {
  yaml_body = file("${path.module}//manifests/unpriviledged.tpl.yml")
  depends_on = [helm_release.opa]
}

resource "kubectl_manifest" "opa_unpriviledged" {
  yaml_body = file("${path.module}//manifests/unpriviledged.yml")
  depends_on = [helm_release.opa]
}