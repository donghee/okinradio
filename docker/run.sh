#!/bin/sh

# bash
#docker run --rm -p 4568:4567 -it -v /home/donghee/src/github.com/donghee/okin.cc/okinradio/radio:/radio ghcr.io/donghee/okinradio:latest bash

# app.rb
#docker run --rm -p 4568:4567 -d --name okin.cc -it -v /home/donghee/src/github.com/donghee/okin.cc/okinradio/radio:/radio ghcr.io/donghee/okinradio:latest
docker run -p 4568:4567 -d --name okin.cc --restart unless-stopped -it -v /home/donghee/src/github.com/donghee/okin.cc/okinradio/radio:/radio ghcr.io/donghee/okinradio:latest
