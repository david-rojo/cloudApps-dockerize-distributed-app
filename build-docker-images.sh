#!/bin/sh

echo '##################'
echo '## EOLO PLANNER ##'
echo '##################'
echo ''

echo 'Starting script'
echo ''

# server
echo 'Building server image...'
docker build -f server/wait-for-it.Dockerfile -t drojo/eoloplanner-server:1.0 .
echo 'Server image built'
echo 'Pushing server image to dockerhub'
docker push drojo/eoloplanner-server:1.0
echo 'Server image published in dockerhub'

echo ''
echo 'Script execution successfully finished!'