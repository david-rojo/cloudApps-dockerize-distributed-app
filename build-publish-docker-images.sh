#!/bin/sh

echo '##################'
echo '## EOLO PLANNER ##'
echo '##################'
echo ''

echo 'Script started'
echo ''

# server
echo 'SERVER'
echo '------'
echo 'Building server image...'
cd server
docker build -f wait-for-it.Dockerfile -t drojo/eoloplanner-server .
cd ..
echo 'Server image built'
docker tag drojo/eoloplanner-server drojo/eoloplanner-server:1.0
echo 'Pushing server images to dockerhub'
docker push drojo/eoloplanner-server
docker push drojo/eoloplanner-server:1.0
echo 'Server images published in dockerhub'
echo ''

# planner
echo 'PLANNER'
echo '-------'
echo 'Building planner image...'
cd planner
docker build -f cache-multistage.Dockerfile -t drojo/eoloplanner-planner .
cd ..
echo 'Planner image built'
docker tag drojo/eoloplanner-planner drojo/eoloplanner-planner:1.0
echo 'Pushing planner images to dockerhub'
docker push drojo/eoloplanner-planner
docker push drojo/eoloplanner-planner:1.0
echo 'Planner images published in dockerhub'
echo ''

# toposervice
echo 'TOPOSERVICE'
echo '-----------'
echo 'Building toposervice image...'
cd toposervice
mvn compile jib:build -Dimage=drojo/eoloplanner-toposervice
echo 'Toposervice image built and published in dockerhub using JIB'
cd ..
echo ''

echo ''
echo 'Script execution successfully finished!'
echo ''