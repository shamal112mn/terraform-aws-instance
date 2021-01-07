provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "mykeypub" {
		key_name = "pub-key"
		public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZwRr7o/snUnsOljhWEMIVYKAD60QkDjPI1JPOMD/lBS3bttiw/7NxQt5GZHZVkzSw+k3G6s+EwK20EhkAHZ5p9znQVjpfchxjZBcU895MqiquB/Is+fgjUWUqFYtbIDFT05gLGmA+vcTSnI6tgYyundquDPoOp/7nKc4Yum2En6XUEhNmkiQBKTMwh0SecrblCpfcqsO63XCZURZ8j/sVJF7IdSuiSe0SpUeW955JDS7PmQcO4GrmFMHY196oOfGjXXdntjT2boXcf+GDPm9rShwvqHi5D+azLuUPaUbSzJU7KntydOW+pmNAaAoM1kB92m4RdfpD1qSY0C3CDdu3 root@docker"
}

data "aws_ami" "my_ami" {
		most_recent = true
		filter {
		name = "name"
		values = ["dev-66752d1b-320a-4c12-bf42-233eb7f2c331*"]
		}
		filter {
		name = "virtualization-type"
		values = ["hvm"]
		}
		 owners           = ["self"] 
	}


resource "aws_instance" "web" {
  key_name = aws_key_pair.mykeypub.key_name
  instance_type = "t2.micro"
  ami           = data.aws_ami.my_ami.id
  
   security_groups = ["${aws_security_group.sg_web.id}"]

   

  tags = {
    Name = "dev-instance"
  }
}

 

resource "aws_security_group" "sg_web" {
  name = "web"
  description = "Allow TLS inbound traffic"

    ingress {
    description = "TLS from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
     ingress {
    description = "TLS from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
     egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

