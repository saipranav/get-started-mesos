#!/bin/bash
DATACENTER=dc1
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

sudo tee /etc/docker/mesos-master <<-EOF
CONSUL_IP=localhost
DC=$DATACENTER
MESOS_HOSTNAME_LOOKUP=false
MESOS_IP=$IP_ADDRESS
MESOS_ZK=zk://$DATACENTER.zookeeper.service.consul:2181/mesos
MESOS_PORT=5050
MESOS_LOG_DIR=/var/log/mesos
MESOS_QUORUM=1
MESOS_WORK_DIR=/var/lib/mesos
MESOS_CLUSTER=$DATACENTER
EOF

# https://github.com/flyinprogrammer/mesos-master/blob/master/Dockerfile
# https://github.com/flyinprogrammer/mesos-base/blob/master/Dockerfile
docker run --restart=always -d --name=mesos-master --net=host --env-file=/etc/docker/mesos-master flyinprogrammer/mesos-master


# Troubleshooting
# java.lang.UnsatisfiedLinkError: /usr/lib/libmesos-1.2.0.so: libcurl-nss.so.4: cannot open shared object file: No such file or directory

docker stop mesos-master && docker rm mesos-master
mkdir mesos && cd mesos
wget https://raw.githubusercontent.com/flyinprogrammer/mesos-master/master/app.json .

tee Dockerfile <<-EOF
FROM flyinprogrammer/mesos-base
RUN apt-get -y update && \
apt-get -y install libcurl4-nss-dev
COPY app.json /app.json
ENV CONTAINERPILOT=file:///app.json
EXPOSE 5050
CMD ["/bin/containerpilot", "mesos-master"]
EOF

docker build -t "my-mesos-master" .
docker run --restart=always -d --name=mesos-master --net=host --env-file=/etc/docker/mesos-master my-mesos-master