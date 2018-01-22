FROM ruby:2.4.3-alpine

LABEL author="ZRP Aplicacoes Informaticas LTDA <zrp@zrp.com.br>"
LABEL vendor="ZRP Aplicações Informáticas LTDA - ME"
LABEL license="GPLv3"

ENV RUNTIME_PACKAGES="gosu tzdata" \
    RUBY_VERSION=2.4.3 \
    HOME_PATH=/home/app \
    APP_PATH=/home/app/web \
    PATH=/usr/local/bin/:/home/app/web/bin/:/home/app/web/:/home/app/.bundler/bin/:$PATH \
    HISTFILE=/home/app/web/.ash_history \
    BUNDLE_PATH=/home/app/.gems \
    BUNDLE_BIN=/home/app/.gems/bin \
    BUNDLE_APP_CONFIG=/home/app/.gems \
    IRBRC=/home/app/.irbrc

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories ; \
    apk update; \
    apk add --no-cache --update $RUNTIME_PACKAGES;

RUN mkdir $HOME_PATH && \
    echo 'require "irb/completion"' >> "/home/app/.irbrc" && \
    echo 'IRB.conf[:AUTO_INDENT] = true' >> "/home/app/.irbrc" && \
    echo 'IRB.conf[:SAVE_HISTORY] = 1000' >> "/home/app/.irbrc" && \
    echo 'IRB.conf[:HISTORY_FILE] = "/home/app/web/.irb_history"' >> "/home/app/.irbrc"

RUN mkdir $BUNDLE_PATH && \
    echo '---' >> "$BUNDLE_PATH/config" && \
    echo 'BUNDLE_RETRY: "3"' >> "/home/app/.gems/config" && \
    echo 'BUNDLE_JOBS: "4"' >> "/home/app/.gems/config" && \
    echo 'BUNDLE_DISABLE_SHARED_GEMS: "true"' >> "/home/app/.gems/config"

WORKDIR $HOME_PATH
COPY rootfs/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker_entrypoint"]
CMD ["/bin/ash"]
