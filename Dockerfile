FROM ubuntu:14.04

MAINTAINER ian.miell@gmail.com

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy git wget curl build-essential docker.io
    
# Install kubernetes and golang
RUN mkdir -p /repos
WORKDIR /repos
RUN git clone https://github.com/GoogleCloudPlatform/kubernetes.git
RUN wget https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.3.3.linux-amd64.tar.gz
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

# Install etcd
WORKDIR /repos/kubernetes
RUN hack/travis/install-etcd.sh
RUN cp third_party/etcd/etcd* /usr/bin/

# Open apisever to all interfaces
RUN sed -i '/API_HOST=${API_HOST:-127.0.0.1}/ c\API_HOST=${API_HOST:-0.0.0.0}' /repos/kubernetes/hack/local-up-cluster.sh
RUN sed -i '/API_PORT=${API_PORT:-8080}/ c\API_PORT=${API_PORT:-8888}' /repos/kubernetes/hack/local-up-cluster.sh
WORKDIR /

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
