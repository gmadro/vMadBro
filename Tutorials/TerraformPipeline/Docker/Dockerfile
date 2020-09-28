FROM amazonlinux:latest

#Pull down terraform and Packer from HashiCorp
ADD https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip /tmp
ADD https://releases.hashicorp.com/packer/1.6.3/packer_1.6.3_linux_amd64.zip /tmp

#Install unzip the Terraform and Packer executables
RUN yum install unzip -y
RUN unzip /tmp/terraform_0.13.3_linux_amd64.zip -d /usr/local/bin/
RUN unzip /tmp/packer_1.6.3_linux_amd64.zip -d /usr/local/bin/