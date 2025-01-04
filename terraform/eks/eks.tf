module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.26.0"

  cluster_name                   = "eks-cluster"
  cluster_version                = "1.30"
  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  create_node_security_group = true
  eks_managed_node_groups = {
    cloud-people = {
      node_group_name = "node-group-eks"
      instance_types  = ["t3.medium"]

      min_size                     = 1
      max_size                     = 3
      desired_size                 = 2
      subnet_ids                   = [aws_subnet.public_1.id, aws_subnet.public_2.id]
      iam_role_additional_policies = {
        EBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

    }

    cluster_addons = {
      coredns = {
        most_recent = true
      }
      kube-proxy = {
        most_recent = true
      }
      vpc-cni = {
        most_recent = true
      }
      aws-ebs-csi-driver = {
        most_recent = true
      }
    }

  }
}