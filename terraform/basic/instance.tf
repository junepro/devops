resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type.example

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  key_name = aws_key_pair.mykey.key_name

  user_data = templatefile("${path.module}/templates/web.tpl", {
    "region" = var.aws_region
  })

  user_data_replace_on_change = true

  //connection {
  //  type     = "ssh"
  //  user     = "ubuntu"
  //  private_key = file("${path.module}/mykey")
  //  host     = self.public_ip
  //}

  //provisioner "remote-exec" {
  //  inline = [
  //    "sudo apt-get update",
  //    "sudo apt-get -y install nginx",
  //  ]
  //}
  tags = {
    Name = "example"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey-demo"
  public_key = file("${path.module}/mykey.pub")
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "eu-west-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name  = "/dev/xvdh"
  volume_id    = aws_ebs_volume.ebs-volume-1.id
  instance_id  = aws_instance.web.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}