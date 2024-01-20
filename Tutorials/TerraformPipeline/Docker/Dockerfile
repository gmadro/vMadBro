FROM amazonlinux:latest

ENV PACKER_VER=1.10.0
ENV TERRAFORM_VER=1.7.0
ENV PYWINRM_VER=0.4.3

#Pull down terraform and Packer from HashiCorp
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip /tmp
ADD https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip /tmp
ADD https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm /tmp

#Install unzip the Terraform and Packer executables
RUN yum install zip -y
RUN yum install unzip -y
RUN yum install git -y
RUN yum install python-pip -y
RUN yum install jq -y
RUN yum install /tmp/session-manager-plugin.rpm -y
RUN pip install "pywinrm>=${PYWINRM_VER}"
RUN unzip /tmp/terraform_${TERRAFORM_VER}_linux_amd64.zip -d /usr/local/bin/
RUN unzip /tmp/packer_${PACKER_VER}_linux_amd64.zip -d /usr/local/bin/
