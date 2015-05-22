FROM jcarley/consul-template

MAINTAINER Jeff Carley <jeff.carley@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV REFRESHED_AT 2015-05-09

ENV RUBY_VERSION=2.2.1 CONFIGURE_OPTS=--disable-install-doc

RUN apt-get update \
    && apt-get install -qqy --no-install-recommends git curl wget \
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

# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

ENV MYSQL_MAJOR 5.6

RUN echo "deb http://repo.mysql.com/apt/debian/ wheezy mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN buildDeps='build-essential libmysqlclient-dev mysql-client libffi-dev zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps

RUN rbenv install $RUBY_VERSION

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rbenv global $RUBY_VERSION \
    && gem update --system
RUN gem install bundler && rbenv rehash

RUN curl -sL https://deb.nodesource.com/setup | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && npm install npm -g

