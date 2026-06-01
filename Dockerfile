ARG NGINX_BRANCH=mainline
FROM nginx:${NGINX_BRANCH}-alpine AS builder

RUN apk add --no-cache \
    build-base \
    linux-headers \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    wget

ARG MODULE_NAME

WORKDIR /build

COPY . /build/repo/

RUN nginx_version=$(nginx -v 2>&1 | cut -d'/' -f2) && \
    wget -q "https://nginx.org/download/nginx-${nginx_version}.tar.gz" && \
    tar xzf "nginx-${nginx_version}.tar.gz" && \
    mv "nginx-${nginx_version}" nginx-src

WORKDIR /build/nginx-src

RUN ./configure \
    --with-compat \
    --add-dynamic-module=/build/repo/${MODULE_NAME} && \
    make modules
