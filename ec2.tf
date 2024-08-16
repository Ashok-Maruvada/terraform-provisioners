resource "aws_instance" "db" {

    ami = "ami-090252cbe067a9e58"
    vpc_security_group_ids = ["sg-0f10b4b0d09399166"]
    instance_type = "t3.micro"

    # provisioners will run when you are creating resources
    # They will not run once the resources are created
    provisioner "local-exec" {
        command = "echo ${self.private_ip} > private_ips.txt"
        #it will create private_ips.txt file having private ip of instance created above
    }

    provisioner "local-exec" {
        command = "ansible-playbook -i private_ips.txt web.yaml"
        # it will run this command only when the local machine installed with ansible otherwise throughs error
    }

    # we will directly install ansible in remote server and run the ansible-playbooks through connecting with remote server
    # this is nothing but integrating terraform with ansible
    connection {
        type     = "ssh"
        user     = "ec2-user"
        password = DevOps321
        host     = self.public_ip
    }

  provisioner "remote-exec" {
    inline = [
        "sudo dnf install ansible -y",
        "sudo dnf install nginx -y",
        "sudo systemctl start nginx"
    ]
  }
}


#Local-exec
   # Runs commands or scripts on the machine where Terraform is running, such as a local development machine or a CI/CD server. This is useful for local tasks and doesn't require connecting to the newly created resource.
#Remote-exec
    # Runs commands or scripts on the remote resource being provisioned, such as an EC2 instance, after the resource is created. This is useful for remote resource configurations and can be used to bootstrap into a cluster or run a configuration management tool.
