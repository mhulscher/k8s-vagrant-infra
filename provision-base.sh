#!/bin/bash

set -eufo pipefail

# Disable swap
sudo sed 's/\(^UUID.* swap \)/#\1/' -i /etc/fstab
sudo swapoff -a

# Install dependencies
sudo apt-get install --yes apt-transport-https ca-certificates curl gnupg2 htop vim-nox

# Install kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install --yes kubelet kubeadm kubectl kubernetes-cni
