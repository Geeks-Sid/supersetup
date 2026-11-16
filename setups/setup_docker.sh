#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 16.04 & 18.04

# Install docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-engine---community-1
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# Download official Docker GPG key for Ubuntu
curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install nvidia container runtime
# https://github.com/NVIDIA/nvidia-docker/tree/master#upgrading-with-nvidia-docker2-deprecated
distribution="$(
  # shellcheck disable=SC1091
  . /etc/os-release
  echo "$ID$VERSION_ID"
)"
# Download official NVIDIA Docker GPG key
curl --fail --silent --show-error --location https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
# Download official NVIDIA Docker apt repository list for the current distribution
curl --fail --silent --show-error --location "https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list" | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update -y
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
