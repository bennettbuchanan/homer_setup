FROM centos:7

ARG AWS_ACCESS_KEY_ID=""
ARG AWS_SECRET_ACCESS_KEY=""
ARG GIT_USER_EMAIL=""
ARG GIT_USER_NAME=""

RUN yum install -y -q epel-release wget curl nano vim zip unzip openssh-clients openssh

RUN wget https://centos7.iuscommunity.org/ius-release.rpm && \
    rpm -Uvh ius-release*.rpm && \
    yum install -y -q yum-plugin-replace

RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    rpm -Uvh remi-release-7*.rpm

RUN wget https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip?_ga=2.241586498.1718610288.1497385573-1038925605.1494026347 -O terraform_0.9.8_linux_amd64.zip && \
    unzip terraform_0.9.8_linux_amd64.zip && \
    mv terraform /usr/local/bin

RUN yum install -y -q python-pip && \
    pip install awscli

RUN mkdir -p /root/.aws && \
    echo "[default]" >> /root/.aws/credentials &&\
    echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /root/.aws/credentials && \
    echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /root/.aws/credentials

# Confirm we have access the the proper
RUN aws s3 ls

# scality.cloud CIDR 217.182.11.0/25 (north america)
# and 144.217.45.128 (europe)
RUN mkdir -p /root/.ssh && \
    echo "Host *" >>  /root/.ssh/config && \
    echo "  StrictHostKeyChecking no"  >>  /root/.ssh/config && \
    echo "Host *.github.com" >>  /root/.ssh/config && \
    echo "  Hostname ssh.github.com" >>  /root/.ssh/config && \
    echo "  Port 443"   >>  /root/.ssh/config && \
    echo "  IdentityFile /root/.ssh/id_rsa" >> /root/.ssh/config &&\
    ssh-keygen -f /root/.ssh/terraform &&\
    echo "Host 217.182.11.*"  >> /root/.ssh/config &&\
    echo "  IdentityFile /root/.ssh/terraform" >> /root/.ssh/config &&\
    echo "Host 144.217.45.*"  >> /root/.ssh/config &&\
    echo "  IdentityFile /root/.ssh/terraform" >> /root/.ssh/config

COPY $ABSOLUTE_PATH_TO_PRIVATE_KEY /root/.ssh/id_rsa

# TODO: Project is not cloned with the ssh key. Alternatively,
# git clone -b ft/backbeat https://github.com/scality/HOMER
RUN yum -y -q install git && \
    mkdir /work && \
    cd /work \
    git clone -b "$HOMER_BRANCH" git@github.com:scality/HOMER.git

RUN pip install requests

RUN git config --global user.email "$GIT_USER_EMAIL" && \
    git config --global user.name "$GIT_USER_NAME"

COPY open.rc /work/

WORKDIR /work/
