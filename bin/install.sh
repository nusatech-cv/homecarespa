#!/bin/bash -x

COMPOSE_VERSION="1.23.2"
COMPOSE_URL="https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)"
PASSWORD="$1"

install_core() {
  echo "$PASSWORD" | sudo -S DEBIAN_FRONTEND=noninteractive apt-get update
  echo "$PASSWORD" | sudo -S DEBIAN_FRONTEND=noninteractive apt-get install -y -q git tmux gnupg2 dirmngr dbus htop curl libmariadbclient-dev-compat build-essential
}

log_rotation() {
  echo "$PASSWORD" | sudo -S bash <<EOS
mkdir -p /etc/docker
echo '
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "10"
  }
}' > /etc/docker/daemon.json
EOS
}

install_docker() {
  echo "$PASSWORD" | sudo -S curl -fsSL https://get.docker.com/ | sudo -S bash
  echo "$PASSWORD" | sudo -S usermod -a -G docker $USER
  echo "$PASSWORD" | sudo -S curl -L "$COMPOSE_URL" -o /usr/local/bin/docker-compose
  echo "$PASSWORD" | sudo -S chmod +x /usr/local/bin/docker-compose
}

install_ruby() {
  echo "$PASSWORD" | sudo -S curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
  echo "$PASSWORD" | sudo -S curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
  echo "$PASSWORD" | sudo -S curl -sSL https://get.rvm.io | bash -s stable
}

install_ruby() {
  sudo -u $USER bash <<EOS
  echo "$PASSWORD" | gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  echo "$PASSWORD" | curl -sSL https://get.rvm.io | bash -s stable
EOS
}


install_core
log_rotation
install_docker
install_ruby
