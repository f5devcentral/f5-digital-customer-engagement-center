resource "aws_iam_role" "demo-node" {
  name               = "nginx-eks-demo-node-${random_id.random-string.dec}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-node.name
}

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "eks-${random_id.random-string.dec}"
  node_role_arn   = aws_iam_role.demo-node.arn
  subnet_ids      = [aws_subnet.public-subnet.id, aws_subnet.private-subnet.id]
  instance_types  = ["t3.xlarge"]

  remote_access {
    ec2_ssh_key               = aws_key_pair.main.id
    source_security_group_ids = [aws_security_group.sgweb.id]
  }


  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  tags = {
    Name  = "nginx k8s_nodes"
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
