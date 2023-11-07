FROM ubuntu:18.04
MAINTAINER Shiv <shivpathak23@gmail.com>
RUN apt-get update && apt-get install -y telnet dnsutils git jq vim curl openssl unzip default-jre && apt-get clean && rm -rf /var/lib/apt/lists/* && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip
COPY amazonmq-cli-0.2.2 .
ENV NAME  shiv-debug
CMD ["/bin/bash"]
