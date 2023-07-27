#!/bin/bash -x

COMPOSE_VERSION="1.23.2"
COMPOSE_URL="https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)"

install_platform() {
  sudo -u $USER bash <<EOS
  cd /home/$USER
  source /home/$USER/.rvm/scripts/rvm
  rvm install 3.0.1
  rvm use --default 3.0.1
  gem install bundler
  cd platform
  bundle install
  rake render:config
  rake service:all

  
EOS
}

install_platform
