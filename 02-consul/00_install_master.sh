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


# http://leebriggs.co.uk/consul/2016/02/08/infrastructure-service-discovery.html
# http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
docker run --restart=always -d --name=dnsmasq --net=host andyshinn/dnsmasq:2.76 -u root --log-facility=- -q -R -h -S $AWS_DNS -S /consul/$BRIDGE_IP#8600
# using nameserver 172.17.0.1#8600 for domain consul
# using nameserver 10.27.0.2#53
sleep 3

# https://en.wikipedia.org/wiki/Here_document#Unix_shells
sudo tee /etc/resolv.conf <<-EOF
search $DOMAIN_NAME
nameserver $BRIDGE_IP
EOF
sleep 10

# Setup a data directory
sudo mkdir -p /consul/{data,config}
sudo chmod 777 -R /consul

# Setup consul server
cat <<EOF > /consul/config/00_server.json
{
    "advertise_addr": "$IP_ADDRESS",
    "bootstrap_expect": 1,
    "client_addr": "0.0.0.0",
    "datacenter": "$DATACENTER",
    "disable_remote_exec": true,
    "dns_config": {
        "node_ttl": "10s",
        "allow_stale": true,
        "max_stale": "10s",
        "service_ttl": {
            "*": "10s"
        }
    },
    "log_level": "INFO",
    "leave_on_terminate": true,
    "server": true,
    "ui": true
}
EOF
# advertise_addr gives the node address in the cluster
# bootstrap_expect is the minimum amount of nodes to be alive in the cluster while startup so that the node can stand for leader election
# client_addr gives the ability to control the source of who talks to this node
# server to be set as true for this node to act as server (default : false)
# ui to true so that we can get consul-ui (default url : http://localhost:8500/ui/)

# Run the consul container with /consul as volume mounted inside the container so that all configurations go inside the container
sudo docker run --restart=always -d --name=consul -v /consul:/consul --net=host consul:v0.7.0 agent

# check installation
docker exec -it consul consul members
# you will see only one server as member in cluster 
