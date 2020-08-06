FROM amazonlinux:latest

#Pull down terraform and Packer from HashiCorp
ADD https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip /inf
ADD https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip /inf

#Install unzip and extract the Terraform and Packer executables
RUN yum install unzip
RUN cd /inf && unzip terraform_0.12.28_linux_amd64.zip && unzip packer_1.6.0_linux_amd64.zip && rm *.zip