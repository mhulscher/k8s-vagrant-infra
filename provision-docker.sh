#!/bin/bash

set -eufo pipefail

# Install docker as runtime

sudo apt-get install --yes software-properties-common

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
