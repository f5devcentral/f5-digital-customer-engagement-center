resource "aws_iam_role" "demo-master" {
  name               = "nginx-eks-cluster-${random_id.random-string.dec}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-master.name
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.demo-master.name
}


resource "aws_eks_cluster" "demo" {
  name     = "${var.cluster-name}-${random_id.random-string.dec}"
  role_arn = aws_iam_role.demo-master.arn
  tags = {
    Nginx = "nginx experience ${random_id.random-string.dec}"
  }

  vpc_config {
    security_group_ids = [aws_security_group.sgweb.id]
    subnet_ids         = [aws_subnet.private-subnet.id, aws_subnet.public-subnet.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy,
  ]
}
