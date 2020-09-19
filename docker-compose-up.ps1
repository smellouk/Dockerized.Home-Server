docker-compose -p "network" -f .\compose-non-ssl\network-compose.yaml --env-file .env up -d
docker-compose -p "container-manager" -f .\compose-non-ssl\container-manager-compose.yaml --env-file .env up -d
docker-compose -p "media" -f .\compose-non-ssl\media-compose.yaml --env-file .env up -d
docker-compose -p "monitoring" -f .\compose-non-ssl\monitoring-compose.yaml --env-file .env up -d