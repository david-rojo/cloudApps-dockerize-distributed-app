#!/bin/sh

DOCKERHUB_NAME=drojo

cat doc/banner/banner.txt
echo ''

echo 'Script started'
echo 'This script builds and publishes docker images version latest and 1.0 in dockerhub for each service'
echo ''

echo 'dockerhub user: '$DOCKERHUB_NAME
echo ''

# server
echo ' --------'
echo '| SERVER |'
echo ' --------'
echo ''
cd server
echo 'Building server image...'
docker build -t $DOCKERHUB_NAME/eoloplanner-server .
echo 'Server image built'
cd ..
docker tag $DOCKERHUB_NAME/eoloplanner-server $DOCKERHUB_NAME/eoloplanner-server:1.0
echo 'Pushing server images to dockerhub'
docker push $DOCKERHUB_NAME/eoloplanner-server
docker push $DOCKERHUB_NAME/eoloplanner-server:1.0
echo 'Server images published in dockerhub'
echo ''

# planner
echo ' ---------'
echo '| PLANNER |'
echo ' ---------'
echo ''
cd planner
echo 'Building planner image...'
docker build -t $DOCKERHUB_NAME/eoloplanner-planner .
echo 'Planner image built'
cd ..
docker tag $DOCKERHUB_NAME/eoloplanner-planner $DOCKERHUB_NAME/eoloplanner-planner:1.0
echo 'Pushing planner images to dockerhub'
docker push $DOCKERHUB_NAME/eoloplanner-planner
docker push $DOCKERHUB_NAME/eoloplanner-planner:1.0
echo 'Planner images published in dockerhub'
echo ''

# toposervice
echo ' -------------'
echo '| TOPOSERVICE |'
echo ' -------------'
echo ''
cd toposervice
echo 'Building toposervice image...'
mvn compile jib:build -Dimage=$DOCKERHUB_NAME/eoloplanner-toposervice
# is specified in toposervice/pom.xml that versions latest and 1.0 will be built and published
echo 'Toposervice images built and published in dockerhub using JIB'
cd ..
echo ''

# weatherservice
echo ' ----------------'
echo '| WEATHERSERVICE |'
echo ' ----------------'
echo ''
cd weatherservice
echo 'Building weatherservice image...'
pack build $DOCKERHUB_NAME/eoloplanner-weatherservice --path . --builder gcr.io/buildpacks/builder:v1
echo 'Weatherservice image built using Buildpacks'
cd ..
docker tag $DOCKERHUB_NAME/eoloplanner-weatherservice $DOCKERHUB_NAME/eoloplanner-weatherservice:1.0
echo 'Pushing weatherservice images to dockerhub'
docker push $DOCKERHUB_NAME/eoloplanner-weatherservice
docker push $DOCKERHUB_NAME/eoloplanner-weatherservice:1.0
echo 'Weatherservice images published in dockerhub'
echo ''

echo 'Script execution successfully finished!'
echo ''

exit 0