#!/usr/bin/env bash

if [ "$PORT" = "443" ] && test -z "$SERVER_KEY" && test -z "$SERVER_CRT"; then
  set -x
  export SERVER_KEY=/go/src/app/default_server.key
  export SERVER_CRT=/go/src/app/default_server.crt
  openssl genrsa -out ${SERVER_KEY} 2048 && \
  openssl ecparam -genkey -name secp384r1 -out ${SERVER_KEY} && \
  openssl req -new -x509 -sha256 -key ${SERVER_KEY} -out ${SERVER_CRT} -days 3650 \
    -subj "/C=US/ST=OR/L=Portland/O=None/OU=None/CN=localhost"
fi

set -x
unstick
