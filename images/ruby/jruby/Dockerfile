FROM jcarley/consul-template

MAINTAINER Jeff Carley <jeff.carley@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV REFRESHED_AT 2015-05-09

ENV RUBY_VERSION=jruby-1.7.20 CONFIGURE_OPTS=--disable-install-doc

RUN apt-get update \
    && apt-get install -qqy --no-install-recommends \
    git \
    curl \
    wget \
    openjdk-7-jdk \
    openjdk-7-jre-headless \
    && update-java-alternatives -a \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY installer.sh /installer.sh
RUN chmod +x /installer.sh \
    && ./installer.sh

ENV HOME /root
ENV RBENV_ROOT $HOME/.rbenv
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH

RUN rbenv init -

# skip installing gem documentation
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

RUN buildDeps='build-essential' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rbenv install $RUBY_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get purge -y --auto-remove $buildDeps

RUN rbenv global $RUBY_VERSION
RUN gem update --system
RUN gem install bundler && rbenv rehash

RUN curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm install npm -g

