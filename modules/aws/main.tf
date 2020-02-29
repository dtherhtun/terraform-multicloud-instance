data "aws_vpc" "default" {
  default = true
}

module "instance_sg" {
  source  = "DTherHtun/sg/aws"
  version = "0.2.1"
  vpc_id  = data.aws_vpc.default.id
  ingress_rules = [
    {
      port        = 8080
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "iam_instance_profile" {
  source  = "DTherHtun/iip/aws"
  actions = ["logs:*", "ec2:DescribeInstances"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = var.ssh_keypair
  vpc_security_group_ids      = [module.instance_sg.security_group.id]
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/templates/startup.sh", { NAME = var.environment.name, BG_COLOR = var.environment.background_color })
  iam_instance_profile        = module.iam_instance_profile.name

  tags = {
    Name = "aws-vm"
  }
}
