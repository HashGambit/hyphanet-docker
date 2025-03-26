#!/bin/bash

sudo docker build --no-cache-filter install -t jdk9:alpine ~/docker/jdk9/alpine && \
sudo docker build --no-cache-filter install -t hashgambit/hyphanet:latest -t hashgambit/hyphanet:jre9 ~/docker/hyphanet # && \
sudo docker push -a hashgambit/hyphanet
