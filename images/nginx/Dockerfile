FROM jcarley/consul-template

MAINTAINER Jeff Carley <jeff.carley@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV REFRESHED_AT 2015-05-09

RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" > /etc/apt/sources.list.d/nginx.list
RUN echo "deb-src http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list.d/nginx.list
RUN wget -qO- http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-get -qqy update && \
    apt-get install -qqy nginx ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Default Variables
ENV CONSUL consul:8500
ENV SERVICE consul-8500

# Setup Consul Template Files
RUN mkdir /etc/consul-templates
RUN mkdir /etc/nginx/sites-enabled

# Setup nginx configuration
RUN rm -fv /etc/nginx/conf.d/\*.conf
ADD nginx/nginx.conf /etc/nginx/nginx.conf

ADD template/ /etc/consul-template/
ADD launch.sh /launch.sh
ADD nginx-run.sh /nginx-run.sh

RUN chmod +x /launch.sh
RUN chmod +x /nginx-run.sh

EXPOSE 80 443

CMD ["/launch.sh"]
