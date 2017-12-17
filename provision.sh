#!/bin/bash

set -eufo pipefail

# Disable swap
sudo sed 's/\(^UUID.* swap \)/#\1/' -i /etc/fstab
sudo swapoff -a

# Install dependencies
sudo apt-get install --yes apt-transport-https ca-certificates curl gnupg2 software-properties-common htop vim-nox

# Install Docker
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

mkdir -pv /etc/systemd/system/docker.service.d
cat <<EOF > /etc/systemd/system/docker.service.d/10-dropin.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --storage-driver=overlay2 --log-driver=json-file --log-opt=max-size=10m --log-opt=max-file=5
EOF

sudo apt-get update
sudo apt-get install --yes docker-ce
sudo usermod -aG docker vagrant

# Install kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install --yes kubelet kubeadm kubectl kubernetes-cni
