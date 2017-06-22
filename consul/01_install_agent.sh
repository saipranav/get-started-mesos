# Datacenter name can be anything, organization have some name for each datacenter
# Why : Consul is data center aware so we need this parameter to start consul
DATACENTER=dc1

# Domain Name Server for our AWS instances something like 10.29.0.1
# Why :
AWS_DNS=$(cat /etc/resolv.conf |grep -i nameserver|head -n1|cut -d ' ' -f2)

# Docker Bridge IP something like 172.17.0.1
# Why :
BRIDGE_IP=$(docker run --rm alpine sh -c "ip ro get 8.8.8.8 | awk '{print \$3}'")

# Domain name of AWS instances something like ec2.internal from
# Why :
DOMAIN_NAME=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname | cut -d "." -f 2-)

# Private ip address for the instance
# Why :
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# TODO : Hardcoded as of now how to get this dynamically
# Use new retry-join-ec2-tag feature
# Why : agent needs to know to which server it has to register and join the cluster, can be a list of ips too
# https://stackoverflow.com/a/38750676
CONSUL_SERVER_IP=<Private ip of the master instance>

# dnsmasq
docker run --restart=always -d --name=dnsmasq --net=host andyshinn/dnsmasq:2.76 -u root --log-facility=- -q -R -h -S $AWS_DNS -S /consul/$BRIDGE_IP#8600

# /etc/resolve.conf
sudo tee /etc/resolv.conf <<-EOF
nameserver $BRIDGE_IP
search $DOMAIN_NAME
EOF

# Setup a data directory
sudo mkdir -p /consul/{data,config}
sudo chmod 777 -R /consul

# Setup consul agent
cat <<EOF > /consul/config/00_server.json
{
    "bind_addr": "$IP_ADDRESS",
    "client_addr": "0.0.0.0",
    "retry_join": "$CONSUL_SERVER_IP",
    "datacenter": "$DATACENTER",
    "log_level": "INFO"
}
EOF

# Run the consul container with /consul as volume mounted inside the container so that all configurations go inside the container
docker run --restart=always -d --name=consul -v /consul:/consul --net=host consul:v0.7.0 agent

# check installation
docker exec -it consul consul members
# you will see all member in cluster 