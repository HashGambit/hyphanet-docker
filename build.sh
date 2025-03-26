#!/bin/bash

sudo docker build --no-cache-filter install -t hashgambit/hyphanet:latest -t hashgambit/hyphanet:jre11 ~/docker/hyphanet && \
sudo docker push -a hashgambit/hyphanet
