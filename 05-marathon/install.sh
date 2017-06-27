#!/bin/bash
CLUSTER_NAME=dc1
PUBLIC_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

# Create configurations file for mesos slave
sudo tee /etc/docker/marathon <<-EOF
CONSUL_IP=localhost
DC=$CLUSTER_NAME
MARATHON_MASTER=zk://$CLUSTER_NAME.zookeeper.service.consul:2181/mesos
MARATHON_ZK=zk://$CLUSTER_NAME.zookeeper.service.consul:2181/marathon
MARATHON_HOSTNAME=$PUBLIC_HOSTNAME
MARATHON_FRAMEWORK_NAME=$CLUSTER_NAME-marathon
EOF

sudo docker run --restart=always -d --name=marathon --net=host --env-file=/etc/docker/marathon flyinprogrammer/marathon

# Troubleshooting
# warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8): No such file or directory
docker stop marathon && docker rm marathon
mkdir marathon && cd marathon
wget https://raw.githubusercontent.com/flyinprogrammer/docker-marathon/master/app.json .

tee Dockerfile <<-EOF
FROM flyinprogrammer/mesos-base
RUN apt-get -y update && \
apt-get -y install locales libcurl4-nss-dev
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
COPY app.json /app.json
ENV CONTAINERPILOT=file:///app.json
EXPOSE 5050
CMD ["/bin/containerpilot", "/usr/bin/marathon"]
EOF

docker build -t "my-marathon" .
docker run --restart=always -d --name=marathon --net=host --env-file=/etc/docker/marathon my-marathon