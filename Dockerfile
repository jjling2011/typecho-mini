ARG DOMAIN="www.typecho.test"
ARG TYPECHO_URL="https://github.com/typecho/typecho/releases/download/v1.2.1/typecho.zip"

ARG BUILDER_TYPECHO_DIR="/root/typecho"
ARG BUILDER_CERT_DIR="/root/ssl"

FROM alpine:3.15.6 AS builder

ARG DOMAIN
ARG TYPECHO_URL
ARG BUILDER_TYPECHO_DIR
ARG BUILDER_CERT_DIR

WORKDIR /root 

RUN apk --update --no-cache add unzip openssl wget \
  && mkdir -p ${BUILDER_TYPECHO_DIR} ${BUILDER_CERT_DIR} \
  && wget -nv --tries=3 -O /root/typecho.zip  ${TYPECHO_URL} \
  && unzip -q /root/typecho.zip -d ${BUILDER_TYPECHO_DIR} \
  && cd ${BUILDER_CERT_DIR} \
  && openssl req -newkey rsa:2048 -nodes -subj "/C=CA/ST=None/L=NB/O=None/CN=${DOMAIN}" -keyout server.key -x509 -days 3650 -out server.crt

FROM alpine:3.15.6

ARG BUILDER_CERT_DIR
ARG BUILDER_TYPECHO_DIR
ARG HTTP_DOC_DIR="/var/www/html"
ARG SSL_DIR="/etc/nginx/conf.d"
ARG NGINX_DIRS="/var/lib/nginx /var/log/nginx"

RUN apk add --update --no-cache nginx nginx-mod-http-dav-ext \
  php8 php8-fpm php8-json php8-pdo_sqlite php8-mbstring \
  php8-ctype php8-curl php8-session php8-tokenizer \
  && mkdir -p ${SSL_DIR} ${NGINX_DIRS} ${HTTP_DOC_DIR}

COPY --from=builder ${BUILDER_CERT_DIR}/ ${SSL_DIR}/
COPY --from=builder ${BUILDER_TYPECHO_DIR}/ ${HTTP_DOC_DIR}/
COPY rootfs /

RUN chown -R nobody:nobody /run ${HTTP_DOC_DIR} ${NGINX_DIRS} \
  && chmod a+r ${SSL_DIR}/*

USER nobody

EXPOSE 443

CMD ["/bin/sh", "/init.sh"]
