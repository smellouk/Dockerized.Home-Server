#!/bin/bash
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

while getopts ":e:s:" opt; do
  case $opt in
    e) env="$OPTARG"
    ;;
    s) ssl="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Defaults
if [ -z "$ssl" ]; then
  ssl="true"
fi

if [ -z "$env" ]; then
  env=".env"
fi

if [ $ssl = "false" ]
then
  base_compose_path="./compose-non-ssl"
else 
  base_compose_path="./compose"
fi

printf "${BLUE}------------- Params${NC}"
echo ""
printf "${YELLOW}Enable ssl:${NC} $ssl"
echo ""
printf "${YELLOW}Base compose path:${NC} $base_compose_path"
echo ""
printf "${YELLOW}Environment variables path:${NC} $env"
echo ""


echo ""
printf "${BLUE}------------- Docker Image${NC}"
echo ""
printf "${YELLOW}Nextcloud SMB${NC}"
echo ""
./dockerfiles/nextcloud/build.sh

echo ""
printf "${BLUE}------------- Docker compose${NC}"
echo ""
printf "${YELLOW}Network Stack${NC}"
echo ""
docker-compose -p "network" -f "$base_compose_path/network-compose.yaml" --env-file "$env" up -d

echo ""
printf "${YELLOW}Container Manager Stack${NC}"
echo ""
docker-compose -p "container-manager" -f "$base_compose_path/container-manager-compose.yaml" --env-file "$env" up -d

echo ""
printf "${YELLOW}Media Stack${NC}"
echo ""
docker-compose -p "media" -f "$base_compose_path/media-compose.yaml" --env-file "$env" up -d

echo ""
printf "${YELLOW}Monitoring Stack${NC}"
echo ""
docker-compose -p "monitoring" -f "$base_compose_path/monitoring-compose.yaml" --env-file "$env" up -d

echo ""
printf "${YELLOW}Cloud Stack${NC}"
echo ""
docker-compose -p "cloud" -f "$base_compose_path/cloud-compose.yaml" --env-file "$env" up -d

### This code is needed to enable internal communication between collabora and nextcloud using domain name
echo ""
printf "${BLUE}------------- Hosts cmd${NC}"
echo ""
printf "${YELLOW}Add cloud-net to iptables for host access${NC}"
echo ""
network_id=$(docker network ls --format "{{.ID}}" --filter name=cloud-net)
sudo iptables -I INPUT 3 -i "br-$network_id" -j ACCEPT
printf "Network${YELLOW}[br-$network_id]${NC} added to iptables!"
echo ""
