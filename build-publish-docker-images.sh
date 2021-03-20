#!/bin/sh

echo '##################'
echo '##################'
echo '## EOLO PLANNER ##'
echo '##################'
echo '##################'
echo ''

echo 'Script started'
echo ''

# Build and publish docker image versions latest and 1.0 for each service

# server
echo ' --------'
echo '| SERVER |'
echo ' --------'
cd server
echo 'Building server image...'
docker build -f wait-for-it.Dockerfile -t drojo/eoloplanner-server .
echo 'Server image built'
cd ..
docker tag drojo/eoloplanner-server drojo/eoloplanner-server:1.0
echo 'Pushing server images to dockerhub'
docker push drojo/eoloplanner-server
docker push drojo/eoloplanner-server:1.0
echo 'Server images published in dockerhub'
echo ''

# planner
echo ' ---------'
echo '| PLANNER |'
echo ' ---------'
cd planner
echo 'Building planner image...'
docker build -f cache-multistage.Dockerfile -t drojo/eoloplanner-planner .
echo 'Planner image built'
cd ..
docker tag drojo/eoloplanner-planner drojo/eoloplanner-planner:1.0
echo 'Pushing planner images to dockerhub'
docker push drojo/eoloplanner-planner
docker push drojo/eoloplanner-planner:1.0
echo 'Planner images published in dockerhub'
echo ''

# toposervice
echo ' -------------'
echo '| TOPOSERVICE |'
echo ' -------------'
cd toposervice
echo 'Building toposervice image...'
mvn compile jib:build -Dimage=drojo/eoloplanner-toposervice
# is specified in toposervice/pom.xml that versions latest and 1.0 will be built and published
echo 'Toposervice images built and published in dockerhub using JIB'
cd ..
echo ''

# weatherservice
echo ' ----------------'
echo '| WEATHERSERVICE |'
echo ' ----------------'
cd weatherservice
echo 'Building weatherservice image...'
pack build drojo/eoloplanner-weatherservice --path . --builder gcr.io/buildpacks/builder:v1
echo 'Weatherservice image built using Buildpacks'
cd ..
docker tag drojo/eoloplanner-weatherservice drojo/eoloplanner-weatherservice:1.0
echo 'Pushing weatherservice images to dockerhub'
docker push drojo/eoloplanner-weatherservice
docker push drojo/eoloplanner-weatherservice:1.0
echo 'Weatherservice images published in dockerhub'
echo ''

echo 'Script execution successfully finished!'
echo ''
