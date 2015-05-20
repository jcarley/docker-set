#!/usr/bin/env bash

docker run -d --net="host" -v /home/jcarley/pipeline/images/plex/config:/config -v /home/jcarley/pipeline/images/plex/data:/data -p 32400:32400 plex
