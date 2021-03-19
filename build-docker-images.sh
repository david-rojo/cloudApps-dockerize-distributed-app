#!/bin/sh

# server
docker build -f server/wait-for-it.Dockerfile -t drojo/eoloplanner-server:1.0 .
docker push drojo/eoloplanner-server:1.0