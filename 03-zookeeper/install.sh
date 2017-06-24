#!/bin/bash
DATACENTER=dc1
#BUCKET=exhibitor-bucket
#BUCKET_PREFIX=sravichandran-sandbox
HOSTNAME=$(hostname -f)

sudo tee /etc/docker/exhibitor <<-EOF
CONSUL_IP=localhost
DC=$DATACENTER
EXHIBITOR_HOSTNAME=$HOSTNAME
EOF

# creating directories for zookeeper to store information
sudo mkdir -p /opt/zk/transactions /opt/zk/snapshots
sudo chmod -R 777 /opt/zk

# https://github.com/flyinprogrammer/docker-exhibitor/blob/master/Dockerfile
sudo docker run --restart=always -d \
                --name=exhibitor \
                --net=host \
                --env-file=/etc/docker/exhibitor \
                -v /opt/zk/transactions:/opt/zk/transactions \
                -v /opt/zk/snapshots:/opt/zk/snapshots \
                flyinprogrammer/exhibitor