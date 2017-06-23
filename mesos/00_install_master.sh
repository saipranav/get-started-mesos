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
# sudo docker run --restart=always -d --name=mesos-master --net=host --env-file=/etc/docker/mesos-master flyinprogrammer/mesos-master