FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade

RUN apt-get install -y git curl build-essential wget zip unzip vim subversion perl bc maven cpanminus

RUN mvn --version

RUN curl -s "https://get.sdkman.io" | bash

RUN source "/root/.sdkman/bin/sdkman-init.sh" \
    && sdk install java 8.0.432-amzn

ENV PATH=/root/.sdkman/candidates/java/current/bin:$PATH

RUN java -version && javac -version

RUN apt-get install -y python3-all python3-venv python3-pip python3-wheel gcc

RUN git clone https://github.com/DCallaz/defects4j-mf.git

WORKDIR /defects4j-mf

RUN ./setup.sh

ENV D4J_HOME="/defects4j-mf/defects4j/"

ENV PATH="${PATH}:${D4J_HOME}/framework/bin"

RUN defects4j_multi -h
