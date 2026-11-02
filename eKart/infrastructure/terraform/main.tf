module "vpc" {
  source = "./modules/vpc"
  aws_region = var.aws_region
}

module "ecr" {
  source = "./modules/ecr"
  account_id = var.account_id
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  instance_class = var.rds_instance_class
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  node_group_min_size = var.node_group_min_size
  node_group_max_size = var.node_group_max_size
}

module "alb" {
  source = "./modules/alb"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# Push Docker images to ECR after repositories are created
resource "null_resource" "push_images" {
  depends_on = [module.ecr]
  provisioner "local-exec" {
    command = <<EOT
aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
# Build images (assumes Dockerfiles exist in the repo)
cd ../../frontend && docker build -t ekart-frontend . && docker tag ekart-frontend:latest ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/frontend:latest && docker push ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/frontend:latest
cd ../../backend && docker build -t ekart-backend . && docker tag ekart-backend:latest ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest && docker push ${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

# Deploy Kubernetes manifests using the Kubernetes provider
resource "kubernetes_namespace" "frontend" {
  metadata { name = "frontend" }
}

resource "kubernetes_namespace" "backend" {
  metadata { name = "backend" }
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = "backend"
  }
  data = {
    username = var.db_username
    password = var.db_password
    host     = module.rds.endpoint
    dbname   = var.db_name
  }
  type = "Opaque"
}

# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "ekart-backend"
    namespace = kubernetes_namespace.backend.metadata[0].name
    labels = {
      app = "ekart-backend"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "ekart-backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "ekart-backend"
        }
      }
      spec {
        container {
          name  = "backend"
          image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/backend:latest"
          port {
            container_port = 8000
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.db_credentials.metadata[0].name
            }
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          readiness_probe {
            http_get {
              path = "/health"
              port = 8000
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = 8000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "ekart-backend"
    namespace = kubernetes_namespace.backend.metadata[0].name
    labels = {
      app = "ekart-backend"
    }
  }
  spec {
    selector = {
      app = "ekart-backend"
    }
    port {
      port        = 80
      target_port = 8000
    }
    type = "ClusterIP"
  }
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "ekart-frontend"
    namespace = kubernetes_namespace.frontend.metadata[0].name
    labels = {
      app = "ekart-frontend"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "ekart-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "ekart-frontend"
        }
      }
      spec {
        container {
          name  = "frontend"
          image = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/frontend:latest"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "150m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "ekart-frontend"
    namespace = kubernetes_namespace.frontend.metadata[0].name
    labels = {
      app = "ekart-frontend"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "alb"
    }
  }
  spec {
    selector = {
      app = "ekart-frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "frontend_url" {
  value = kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].hostname
}
