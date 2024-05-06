#!/bin/bash

if ! [ -e "/ssl/ssl.crt" ]; then cp /ssl-default/* /ssl; fi
envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" <   /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -T > /dev/stdout
nginx