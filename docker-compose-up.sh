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
printf "${BLUE}--------- Docker compose${NC}"
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

