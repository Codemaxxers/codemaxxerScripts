#!/bin/bash

cd /deployments/codemaxxers/

# Main Server
cd codemaxxerBackend
docker-compose down
git pull .
docker-compose build --no-cache && docker-compose up -d
cd ..


# Websocket Server
cd codemaxxerConnections
docker-compose down
git pull .
docker-compose build --no-cache && docker-compose up -d
cd ..

# Add more here


