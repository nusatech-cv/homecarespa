#!/bin/bash -x

# Check if openssl is installed, if not, install it
if ! command -v openssl &> /dev/null; then
  echo "openssl could not be found, installing..."
  sudo apt-get update
  sudo apt-get install openssl
fi

# Define path for keys
DIR="config/secrets"
APP_KEY="$DIR/app.key"
EVENT_KEY="$DIR/event.key"
SOCKET_KEY="$DIR/socket.key"

# Check each key and create if it does not exist
for KEY in "$APP_KEY" "$EVENT_KEY" "$SOCKET_KEY"; do
  if [ -e $KEY ]; then
    echo "$KEY already exists, skipping..."
  else
    echo "Creating $KEY..."
    openssl genpkey -algorithm RSA -out $KEY -pkeyopt rsa_keygen_bits:4096
  fi
done
