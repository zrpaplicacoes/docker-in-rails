FROM ruby:2.4.1-alpine

MAINTAINER ZRP Aplicacoes Informaticas LTDA <zrp@zrp.com.br>

LABEL vendor="ZRP Aplicações Informáticas LTDA - ME"
LABEL license="GPLv3"

ENV RUNTIME_PACKAGES="nodejs alpine-sdk nodejs curl tzdata" \
    RUBY_VERSION=2.4.1 \
    GOSU_VERSION=1.10 \
    HOME_PATH=/home/app \
    APP_PATH=/home/app/web \
    PATH=/usr/local/bin/:/home/app/web/bin/:/home/app/web/:/home/app/.gems/bin/:$PATH \
    HISTFILE=/home/app/web/.ash_history \
    GEM_HOME=/home/app/.gems \
    BUNDLE_PATH=/home/app/.gems \
    IRBRC=/home/app/.irbrc

RUN apk add --no-cache --update $RUNTIME_PACKAGES;

RUN set -e; \
    apk add --no-cache --virtual .gosu-deps dpkg gnupg openssl; \
  	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
  	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
  	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
  	export GNUPGHOME="$(mktemp -d)"; \
  	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
  	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
  	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
  	chmod +x /usr/local/bin/gosu; \
  	gosu nobody true; \
  	apk del .gosu-deps

RUN mkdir $HOME_PATH && \
    echo 'require "irb/completion"' >> "$HOME_PATH/.irbrc" && \
    echo 'IRB.conf[:AUTO_INDENT] = true' >> "$HOME_PATH/.irbrc" && \
    echo 'IRB.conf[:SAVE_HISTORY] = 1000' >> "$HOME_PATH/.irbrc" && \
    echo 'IRB.conf[:HISTORY_FILE] = "$APP_PATH/.irb_history"' >> "$HOME_PATH/.irbrc"

# geckodriver
RUN curl -Ls https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz -O && \
    tar xzf geckodriver-v0.16.1-linux64.tar.gz -C /usr/local/bin && \
    chmod a+x /usr/local/bin/geckodriver

# selenium and phantomjs
RUN apk update && \
    curl -Ls "https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz" | tar xz -C / && \
    npm install -g phantomjs-prebuilt && \
    apk add python py-pip curl unzip dbus-x11 ttf-freefont firefox-esr xvfb && \
    pip install 'selenium==3.4.3'

WORKDIR $HOME_PATH
COPY rootfs/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker_entrypoint"]
CMD ["/bin/ash"]
