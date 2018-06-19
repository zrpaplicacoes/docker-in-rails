# Arguments
ARG RUBY_VERSION
ARG LINUX_DIST

# Build from version-dist, e.g ruby:2.5.2-alpine
FROM ruby:${RUBY_VERSION}-${LINUX_DIST}

LABEL author="ZRP Aplicacoes Informaticas LTDA <zrp@zrp.com.br>"
LABEL vendor="ZRP Aplicações Informáticas LTDA - ME"
LABEL license="GPLv3"

# Priority Order
# Application binaries under /home/app/bin [HIGHEST]
# Bundler binaries [HIGH]
# User local binaries [MEDIUM]
# Binaries under application root [LOW]
# All binaries [LOWEST]

ENV RUNTIME_PACKAGES="alpine-sdk shadow less tzdata bash bash-doc bash-completion postgresql-client postgresql-dev mysql-client mysql-dev" \
    RUBY_VERSION=$RUBY_VERSION \
    TZ=America/Sao_Paulo \
    HOME_PATH=/home \
    APP_PATH=/home/app \
    HISTFILE=/home/app/.bash_history \
    BUNDLE_PATH=/home/.gems \
    BUNDLE_BIN=/home/.gems/bin \
    BUNDLE_APP_CONFIG=/home/.gems \
    IRBRC=/home/.irbrc \
    APP_BIN_PATH=/home/app/bin \
    APP_TEMP_PATH=/home/app/tmp \
    PATH=/home/app/bin/:/home/.bundler/bin/:/usr/local/bin/:/home/app/:$PATH

# Set default config and update bundler
WORKDIR $APP_PATH
ENTRYPOINT ["/usr/local/bin/docker_start"]

RUN gem install bundler --no-rdoc --no-ri

# Install dependencies
RUN apk update && apk add --no-cache --update $RUNTIME_PACKAGES

# User managment
RUN addgroup -g 1000 zrpaplicacoes && \
    adduser -u 1000 -G root zrpaplicacoes -s /bin/bash -h /home/app -S -D zrpaplicacoes && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Set IRB autocomplete
RUN echo 'require "irb/completion"' >> "/home/.irbrc" && \
    echo 'IRB.conf[:AUTO_INDENT] = true' >> "/home/.irbrc" && \
    echo 'IRB.conf[:SAVE_HISTORY] = 1000' >> "/home/.irbrc" && \
    echo 'IRB.conf[:HISTORY_FILE] = "/home/app/.irb_history"' >> "/home/.irbrc"

# Set Bundle Config
RUN mkdir $BUNDLE_PATH && \
    echo '---' >> "$BUNDLE_PATH/config" && \
    echo 'BUNDLE_RETRY: "3"' >> "/home/.gems/config" && \
    echo 'BUNDLE_JOBS: "4"' >> "/home/.gems/config" && \
    echo 'BUNDLE_DISABLE_SHARED_GEMS: "true"' >> "/home/.gems/config" && \
    chown -R zrpaplicacoes:zrpaplicacoes $BUNDLE_PATH

# Copy files
COPY --chown=zrpaplicacoes:zrpaplicacoes rootfs/* /usr/local/bin/
COPY --chown=zrpaplicacoes:zrpaplicacoes rootfs/bashrc /etc/bash.bashrc

# Control user
RUN usermod -s /bin/bash root
