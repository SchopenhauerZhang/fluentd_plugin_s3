FROM alpine:3.8
ENV DUMB_INIT_VERSION=1.2.1

ENV SU_EXEC_VERSION=0.2
RUN apk update \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb ruby-etc ruby-webrick \
        su-exec==${SU_EXEC_VERSION}-r0 \
        dumb-init==${DUMB_INIT_VERSION}-r0 \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev gnupg \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.3.10 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v 1.2.6 \
 && gem install bigdecimal -v 1.3.5 \
 && gem install fluent-plugin-add -v 0.0.7 \
 && gem install fluent-plugin-flowcounter -v 1.3.0 \
 && gem install fluent-plugin-s3 -v 1.1.0 \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem


RUN mkdir -p /fluentd/log

RUN mkdir -p /fluentd/etc /fluentd/plugins

RUN addgroup -S fluent && adduser -S -g fluent fluent
RUN chown -R fluent /fluentd && chgrp -R fluent /fluentd

COPY fluent.conf /fluentd/etc/fluent.conf

ENV LD_PRELOAD=""
ENV DUMB_INIT_SETSID 0
EXPOSE 24224 24224

CMD ["fluentd", "-c", "/fluentd/etc/fluent.conf"]


