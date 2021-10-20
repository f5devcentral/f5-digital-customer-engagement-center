resource "aws_lb" "nlb" {
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.vpcMainSubPubA.id]
  #  subnets            = [aws_subnet.vpcMainSubNlbA.id]
  #  subnets            = [aws_subnet.vpcMainSubPrivA.id]

  tags = {
    Name  = "${var.projectPrefix}-nlb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group" "internalTargetGroup" {
  name        = "internalTG-${random_id.buildSuffix.hex}"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpcMain.id

  health_check {
    protocol = "TCP"
    port     = 80
    #    matcher  = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "internalTargetGroupAttachment" {
  target_group_arn = aws_lb_target_group.internalTargetGroup.arn
  target_id        = aws_instance.ubuntuVpcMainSubnetA.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internalTargetGroup.arn
  }
}