FROM amazonlinux:latest

#Pull down terraform and Packer from HashiCorp
ADD https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip /tmp
ADD https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip /tmp

#Install unzip the Terraform and Packer executables
RUN yum install unzip -y
RUN unzip /tmp/terraform_0.12.28_linux_amd64.zip && unzip /tmp/terraform_0.12.28_linux_amd64.zip