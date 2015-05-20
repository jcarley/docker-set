FROM team27/base:latest

RUN sudo apt-get update; sudo apt-get install libreadline-dev -y

COPY ./scripts/puppetize.sh /tmp/puppetize.sh

RUN cd /tmp; ./puppetize.sh
