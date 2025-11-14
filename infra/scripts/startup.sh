#!/bin/bash
set -eux

# Install docker if not present
if ! command -v docker >/dev/null 2>&1; then
  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable"             > /etc/apt/sources.list.d/docker.list
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
fi

# Ensure docker service running
systemctl enable docker
systemctl start docker

# Pull the container image provided via instance metadata (container-image)
CONTAINER_IMAGE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/container-image" -H "Metadata-Flavor: Google")

if [ -z "$CONTAINER_IMAGE" ]; then
  echo "No container image set in instance metadata; exiting"
  exit 0
fi

# Stop existing container if running then remove
if docker ps -a --format '{{.Names}}' | grep -Eq "^fastapi-container$"; then
  docker rm -f fastapi-container || true
fi

# Run container
docker run -d --restart unless-stopped --name fastapi-container -p 80:80 "$CONTAINER_IMAGE"
