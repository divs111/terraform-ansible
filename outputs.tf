output "ec2_public_ip" {
    value = [
        for key in aws_instance.my_instance : 
        {
        public_ip = key.public_ip
        Name = key.tags.Name
        }
    ]
}
