#!/usr/bin/env bash

set -e

if [ -z "${RBENV_ROOT}" ]; then
  RBENV_ROOT="$HOME/.rbenv"
fi

git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

if ! grep -qs "rbenv init" $HOME/.bashrc; then
  printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> $HOME/.bashrc
  printf 'eval "$(rbenv init - --no-rehash)"\n' >> $HOME/.bashrc
fi

# Install plugins:
PLUGINS=(
  "sstephenson:rbenv-vars"
  "sstephenson:ruby-build"
  "sstephenson:rbenv-default-gems"
  "sstephenson:rbenv-gem-rehash"
  "rkh:rbenv-update"
  "rkh:rbenv-whatis"
  "rkh:rbenv-use"
)

for plugin in ${PLUGINS[@]} ; do

  KEY=${plugin%%:*}
  VALUE=${plugin#*:}

  RBENV_PLUGIN_ROOT="${RBENV_ROOT}/plugins/$VALUE"
  if [ ! -d "$RBENV_PLUGIN_ROOT" ] ; then
    git clone https://github.com/$KEY/$VALUE.git $RBENV_PLUGIN_ROOT
  else
    cd $RBENV_PLUGIN_ROOT
    echo "Pulling $VALUE updates."
    git pull
  fi

done
