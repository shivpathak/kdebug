FROM ubuntu:18.04
MAINTAINER Shiv <shivpathak23@gmail.com>
RUN apt-get update && apt-get install -y telnet dnsutils jq vim curl openssl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
ENV NAME  shiv-debug
CMD ["/bin/bash"]
