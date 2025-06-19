#key-pair
resource "aws_key_pair" "my_key" {
    key_name = "terra-ansible-key"
    public_key = file("terra-ansible-key.pub")

    tags = {
      Environment = var.env
    }
}


#vpc and security group
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
    name = "${var.env}.automate_sg"
    description = "this is the TF generated security group"
    vpc_id = aws_default_vpc.default.id

    #inbound-rules
    ingress {
        to_port = 22
        from_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH Open"
    }
    ingress {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Http open"
    }

    #out-bound rules
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open"
    }
    tags = {
      Name = "${var.env}-automate_sg"
    }
}

#ec2 instance

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    for_each = tomap({
        div_master_node = "ami-020cba7c55df1f615"
        div_worker_node1 = "ami-09e6f87a47903347c"
        div_worker_node2 = "ami-020cba7c55df1f615"
    })


    instance_type = "t2.micro"
    ami = each.value
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }
    tags = {
      Name = each.key
      Environment = var.env
    }
}