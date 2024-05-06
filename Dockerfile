ARG VERSION="0.5"
ARG DESCRIPTION="NGINX SSL Proxy"

# ARG BASE_REGISTRY=registry1.dso.mil
# ARG BASE_IMAGE=ironbank/opensource/nginx/nginx
ARG BASE_REGISTRY=docker.io
ARG BASE_IMAGE=nginx
ARG BASE_TAG=latest
FROM $BASE_REGISTRY/$BASE_IMAGE:$BASE_TAG

ARG VERSION
ARG DESCRIPTION
LABEL VERSION=${VERSION}
LABEL DESCRIPTION=${DESCRIPTION}

# Set default port
ENV HTTPS_PORT 443
EXPOSE $HTTPS_PORT

# Volume for Proxy Location files
VOLUME [ "/etc/nginx/conf.d" ]

# SSL Certificates are to be in a mounted volume as ssl.crt and ssl.key
VOLUME [ "/ssl" ]

USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && rm -rf /var/lib/apt/lists/*

COPY ./backend-not-found.html /var/www/html/backend-not-found.html
ADD ssl.tar /ssl-default/
COPY nginx.conf /etc/nginx/nginx.conf.template
# COPY proxy.locations /etc/nginx/proxy.locations.template
COPY --chmod=0744 docker-entrypoint.sh /docker-entrypoint.sh
# RUN chmod +x docker-entrypoint.sh /docker-entrypoint.sh

# USER nginx

HEALTHCHECK --interval=2m --timeout=10s \
  CMD curl -k -f https://localhost:${HTTPS_PORT}/ || exit 1
 
ENTRYPOINT [ "/docker-entrypoint.sh" ]
