provider "aws" {
  region="ap-south-1"
  access_key = var.access
  secret_key = var.secret
}

resource "aws_vpc" "main" {
    cidr_block       = var.main_vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

     tags = {
         Name = "main"
            }
        }


 resource "aws_subnet" "subnet1" {
   vpc_id     = aws_vpc.main.id
   cidr_block = "10.0.1.0/24"
   availability_zone = "ap-south-1a"


  tags  =  {
    Name = "app-subnet-1"
    }
 }

 resource "aws_subnet" "subnet2" {
   vpc_id     = aws_vpc.main.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "ap-south-1b"


     tags  =  {
      Name = "app-subnet-2"
     }
   }

 
 resource "aws_internet_gateway" "main-igw" {
   vpc_id = aws_vpc.main.id

  tags = {
   Name = "main-igw"
   }
   }


resource "aws_route_table" "main-public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "main-public-rt"
  }
}

resource "aws_route_table" "main-private-rt" {
  vpc_id = aws_vpc.main.id

  tags  = {
    Name = "main-private-rt"
  }
}

resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main-public-rt.id
}

resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main-private-rt.id
}

#create ec2 instance

resource "aws_instance" "my-instance" {

  ami                         = "ami-08e0ca9924195beba"
  key_name                    = aws_key_pair.my_key.key_name
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  
  subnet_id = aws_subnet.subnet1.id
  
}

resource "aws_security_group" "my-sg" {
  name   = "my-security-group"
   vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1 #all traffic
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key" {
   key_name   = "new-key"
   public_key =  file("pub_key.pub")
}

variable "access" {
  type = string
}
variable "secret" {
  type = string
}
variable "main_vpc_cidr" {
    description = "CIDR of the VPC"
    default = "10.0.0.0/16"
}
