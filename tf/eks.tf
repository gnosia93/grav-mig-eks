module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.31"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["c6i.2xlarge", "c6g.2xlarge"]
  }

  eks_managed_node_groups = {
    ng-x86 = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["c6i.2xlarge"]

      min_size     = 3
      max_size     = 3
      desired_size = 3
    }
  }

  cloudwatch_log_group_retention_in_days = 1
}

# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

/*
Error: waiting for EKS Node Group (eks-grv-mig:ng-x86-20241209221503109200000015) create: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: i-05f04897353fc76af, i-08cea01975730272b, i-0e21b71b34065f19d: NodeCreationFailure: Instances failed to join the kubernetes cluster
│
│   with module.eks.module.eks_managed_node_group["ng-x86"].aws_eks_node_group.this[0],
│   on .terraform/modules/eks/modules/eks-managed-node-group/main.tf line 392, in resource "aws_eks_node_group" "this":
│  392: resource "aws_eks_node_group" "this" {
*/


