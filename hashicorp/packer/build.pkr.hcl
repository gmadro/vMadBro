variable "image_name" {
  type = string
  description = "Name of image"
  default = "handled-by-pipline"
}

source "amazon-ebs" "aws" {
  ami_name = "${var.image_name}"
  region = "us-east-1"
  instance_type = "t2.micro"
  source_ami = "ami-08f3d892de259504d"
  force_deregister = true
  force_delete_snapshot = true

  ssh_username = "ec2-user"
}

source "vmware-iso" "vmware" {
    iso_url = ""
}

build {
    sources = [
        "source.amazon-ebs.build1"
    ]

    provisioner "file" {
        source = "../../app/"
        destination = "/tmp"
    }

    provisioner "shell" {
        inline = [
            "sudo yum install -y docker",
            "sudo systemctl start docker",
            "sudo docker build /tmp -t vmadbro/apache:1.0",
            "sudo systemctl enable docker",
            "sudo docker run -d --name Apache --restart unless-stopped -p 80:80 vmadbro/apache:1.0"
        ]
    }
}