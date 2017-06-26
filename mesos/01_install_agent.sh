#!/bin/bash
# why directly on instance rather than mesos docker because mesos has some code tied up with systemd and it needs full access to systemd which does not happen all the time via docker.
# TODO cahnge master also to be installed on instance instead of docker

CLUSTER_NAME=dc1

sudo tee /etc/apt/sources.list.d/mesosphere.list <<-EOF
deb http://repos.mesosphere.com/ubuntu xenial main
EOF

sudo apt-get update
sudo apt-get install --allow-unauthenticated -y mesos

sudo systemctl stop zookeeper
sudo systemctl disable zookeeper
sudo systemctl stop mesos-master
sudo systemctl disable mesos-master

sudo tee /etc/default/mesos-slave <<-EOF
MESOS_CGROUPS_LIMIT_SWAP=false
MESOS_CGROUPS_ENABLE_CFS=true
MESOS_CONTAINERIZERS=docker,mesos
MESOS_EXECUTOR_REGISTRATION_TIMEOUT=5mins
MESOS_ISOLATION=cgroups/cpu,cgroups/mem
MESOS_LOG_DIR=/var/log/mesos/agent
MESOS_MASTER=zk://$CLUSTER_NAME.zookeeper.service.consul:2181/mesos
MESOS_PORT=5051
MESOS_WORK_DIR=/var/lib/mesos/agent
MESOS_CLUSTER=$CLUSTER_NAME
EOF
sudo systemctl start mesos-slave


# Consul Registration
sudo tee sudo tee /etc/docker/cp-mesos-slave.json <<-EOF
{
    "consul": "localhost:8500",
    "logging": {
        "level": "INFO",
        "format": "default",
        "output": "stdout"
    },
    "services": [{
        "name": "mesos-agent",
        "port": 5051,
        "health": [
            "/usr/bin/curl",
            "--fail",
            "-s",
            "http://localhost:5051/health"
        ],
        "tags": ["$CLUSTER_NAME"],
        "poll": 10,
        "ttl": 30
    }]
}
EOF
sudo docker run --restart=always -d --net=host -v /etc/docker/cp-mesos-slave.json:/app.json flyinprogrammer/cp