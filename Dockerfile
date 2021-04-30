FROM ubuntu:18.04
MAINTAINER Shiv <shivpathak23@gmail.com>
RUN apt-get update && apt-get install -y telnet dnsutils jq vim curl openssl unzip && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf awscliv2.zip
COPY amazonmq-cli-0.2.2 .
ENV NAME  shiv-debug
CMD ["/bin/bash"]
