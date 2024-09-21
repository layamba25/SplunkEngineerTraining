# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks_cluster_role.arn # This references the IAM role in main.tf

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
    security_group_ids = [aws_security_group.eks_security_group.id]

    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy_attachment
  ]
}

# Fargate Profile
resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "ct-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  selector {
    namespace = "default"
  }

  selector {
    namespace = "awx"
    labels = {
      "app" = "awx-operator"
    }
  }

  selector {
    namespace = "eks-sample-app"
  }

  selector {
    namespace = "argocd"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_vpc_controller_policy_attachment,
    aws_iam_role.fargate_pod_execution_role,
    aws_iam_role_policy_attachment.fargate_worker_node_policy_attachment
  ]
}

