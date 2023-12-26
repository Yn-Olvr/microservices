

module "aws_vpc" {
  source            = "./module/vpc"
  networking        = var.networking
  security_groups   = var.security_groups

}

resource "aws_instance" "Jenkins-Server" {
  
  ami                       = "ami-0fa1ca9559f1892ec"
  instance_type             = "t2.micro"
  subnet_id                 = element(module.aws_vpc.public_subnets_id[0], 2)
  vpc_security_group_ids    = flatten(module.aws_vpc.security_groups_id)
  key_name                  = "my-key-pair"
  user_data                 = file("install_jenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }

}

 

#creating eks cluster
resource "aws_eks_cluster" "python-microservices-cluster" {
  name      = var.cluster-config.name
  role_arn  = "arn:aws:iam::510314780674:role/EKSClusterRole"
  version   = var.cluster-config.version

  vpc_config {
    subnet_ids          = flatten([module.aws_vpc.public_subnets_id, module.aws_vpc.private_subnets_id])
    security_group_ids  = flatten(module.aws_vpc.security_groups_id)
  }

}

# NODE GROUP
resource "aws_eks_node_group" "node-ec2" {
  for_each          = { for node_group in var.node_groups : node_group.name => node_group}
  cluster_name      = aws_eks_cluster.python-microservices-cluster.name
  node_group_name   = each.value.name
  node_role_arn     = aws_iam_role.NodeGroupRole.arn
  subnet_ids        = flatten(module.aws_vpc.private_subnets_id)

  scaling_config {
    desired_size = try(each.value.scaling_config.desired_size, 2)
    max_size     = try(each.value.scaling_config.max_size, 3)
    min_size     = try(each.value.scaling_config.min_size, 1)
  }

  update_config {
    max_unavailable = try(each.value.update_config.max_unavailable, 1)
  }

  ami_type = each.value.ami_type
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}

/* resource "aws_eks_addon" "addons" {
  for_each                      = {for addon in var.addons : addon.name => addon}
  cluster_name                  = aws_eks_cluster.python-microservices-cluster.name
  addon_name                    = each.value.name
  addon_version                 = each.value.version
  resolve_conflicts_on_create   = "OVERWRITE"
  
} */

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.python-microservices-cluster.name
  addon_name = "coredns"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.python-microservices-cluster.name
  addon_name = "kube-proxy"
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.python-microservices-cluster.name
  addon_name = "vpc-cni"
}