FROM alpine:3.9
LABEL "Mail":"kljxnn@gmail.com"\
      "version":"v1.3.0"
ENV RUN_USER daemon
ENV RUN_GROUP daemon
ENV INSTALL_DIR /opt/navi
ENV DB_HOST 172.18.0.4
ENV DB_PORT 3306
ENV DB_DATABASE webstack
ENV DB_USERNAME root
ENV DB_PASSWORD root
ENV LOGIN_COPTCHA true
ENV ENTRYPOINT_CHOICE new-server


ARG DOWNLOAD_URL=http://file.iyzyi.com/package/WebStack-Laravel/WebStack-Laravel-1.3.1.tar.gz
EXPOSE 8000

COPY entrypoint.sh /entrypoint.sh
RUN apk update -qq \
        && apk upgrade \
        && apk add --no-cache tini \
           curl composer \
       php-pdo php-fileinfo  php-tokenizer php-gd php-dom  php-xmlwriter php-xml php-pdo_mysql php-session \
    && rm -rf /var/cache/apk/* \
    && mkdir -p ${INSTALL_DIR}
RUN apk add --no-cache php7-simplexml

RUN curl -L --silent  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${INSTALL_DIR}" \
    && cd ${INSTALL_DIR} \
    && composer install  \
    && cp .env.example .env \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${INSTALL_DIR}\
    && chown -R ${RUN_USER}:${RUN_GROUP} /entrypoint.sh
RUN chmod 777 /entrypoint.sh

#RUN : \
#    && /bin/echo -e '#!/bin/sh\n' >> /run.exe \
#    && bin/echo "/entrypoint.sh ${ENTRYPOINT_CHOICE}" >> /run.exe \
#    && chmod +x /run.exe
#CMD ["/run.exe"]
CMD /entrypoint.sh ${ENTRYPOINT_CHOICE}

WORKDIR ${INSTALL_DIR}
