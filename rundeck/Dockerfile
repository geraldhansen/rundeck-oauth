FROM rundeck/rundeck:5.4.0
LABEL maintainer="ger@ldhansen.de"
LABEL description="Rundeck container with integrated OAuth"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ARG OAUTH_PROXY_VERSION=7.6.0

USER root

# Preauth headers nginx part and oauth2 proxy
RUN apt-get update -q
RUN apt-get install --assume-yes --allow-unauthenticated \
       nginx
COPY ./etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default
COPY --chown=rundeck:root ./home/rundeck/docker-lib/includes/101_pre_auth.sh /home/rundeck/docker-lib/includes/101_pre_auth.sh
COPY --chown=rundeck:root ./home/rundeck/etc/admin.aclpolicy /home/rundeck/etc/admin.aclpolicy
RUN curl -L https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${OAUTH_PROXY_VERSION}/oauth2-proxy-v${OAUTH_PROXY_VERSION}.linux-amd64.tar.gz | tar zxf -
RUN mv oauth2-proxy-v${OAUTH_PROXY_VERSION}.linux-amd64/oauth2-proxy /usr/local/bin/oauth2-proxy       
RUN touch /var/log/oauth2-proxy.log
RUN chown rundeck: /var/log/oauth2-proxy.log

USER rundeck
WORKDIR /home/rundeck

HEALTHCHECK CMD curl --fail --silent --output /dev/null http://localhost:4440/user/login || exit 1
