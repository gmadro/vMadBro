FROM amazonlinux:latest

#Pull down terraform and Packer from HashiCorp
ADD https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip /tmp
ADD https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip /tmp
ADD https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm /tmp

#Install unzip the Terraform and Packer executables
RUN yum install unzip -y
RUN yum install /tmp/session-manager-plugin.rpm -y
RUN unzip /tmp/terraform_0.13.4_linux_amd64.zip -d /usr/local/bin/
RUN unzip /tmp/packer_1.6.4_linux_amd64.zip -d /usr/local/bin/