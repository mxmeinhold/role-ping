FROM debian:buster-slim
LABEL maintainer="Max Meinhold <mxmeinhold@gmail.com>"

EXPOSE 8080

ENV NODE_ENV production

RUN mkdir /opt/role-ping
WORKDIR /opt/role-ping

# Yarn and nvm install deps
RUN rm /bin/sh \
    && ln -s /bin/bash /bin/sh \
    && apt-get update \
    && apt-get install -y curl gnupg \
    && apt-get -y autoclean

# Yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && apt-get -y autoclean

# NVM and node install
ENV NODE_VERSION 14.8.0

ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR \
    && curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash

RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \ 
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY package.json yarn.lock ./

RUN yarn

COPY . /opt/role-ping

USER 1001

# Sleep a random interval between 0 and 8 hours
CMD sleep $[ ( $RANDOM % 28800 ) ]s; node main.js
