FROM ubuntu:18.04
MAINTAINER Shiv <shivpathak23@gmail.com>
RUN apt-get update && apt-get install -y telnet dnsutils jq vim curl openssl && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV NAME  shiv-debug
CMD ["/bin/bash"]
