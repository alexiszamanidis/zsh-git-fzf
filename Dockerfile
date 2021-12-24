FROM ubuntu:focal
ARG TAGS
ENV USER=root
WORKDIR /usr/local/bin
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml && zsh"]
