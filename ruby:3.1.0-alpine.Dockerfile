FROM ruby:3.1.0-alpine

LABEL author="ZRP Aplicacoes Informaticas LTDA <zrp@zrp.com.br>"
LABEL vendor="ZRP Aplicações Informáticas LTDA - ME"
LABEL license="GPLv3"

ENV RUNTIME_PACKAGES="alpine-sdk curl tzdata" \
    RUBY_VERSION=3.1.0 \
    HOME_PATH=/home \
    APP_PATH=/home/app \
    PATH=/usr/local/bin/:/home/app/bin/:/home/app/:/home/.bundler/bin/:$PATH \
    HISTFILE=/home/app/.ash_history \
    BUNDLE_PATH=/home/.gems \
    BUNDLE_BIN=/home/.gems/bin \
    BUNDLE_APP_CONFIG=/home/.gems \
    IRBRC=/home/.irbrc

RUN addgroup -g 1000 app \
    && adduser -u 1000 -G app -s /bin/sh -D app \
    && apk update \
    && apk add --no-cache --update $RUNTIME_PACKAGES

RUN echo 'require "irb/completion"' >> "/home/.irbrc" && \
    echo 'IRB.conf[:AUTO_INDENT] = true' >> "/home/.irbrc" && \
    echo 'IRB.conf[:SAVE_HISTORY] = 1000' >> "/home/.irbrc" && \
    echo 'IRB.conf[:HISTORY_FILE] = "/home/app/.irb_history"' >> "/home/.irbrc"

RUN mkdir $BUNDLE_PATH && \
    echo '---' >> "$BUNDLE_PATH/config" && \
    echo 'BUNDLE_RETRY: "3"' >> "/home/.gems/config" && \
    echo 'BUNDLE_JOBS: "4"' >> "/home/.gems/config" && \
    echo 'BUNDLE_DISABLE_SHARED_GEMS: "true"' >> "/home/.gems/config"

WORKDIR $APP_PATH
COPY rootfs/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.new"]
CMD ["/bin/ash"]
