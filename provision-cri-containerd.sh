#!/bin/bash

set -eufo pipefail

# Install cri-containerd as runtime

## weave cni
mkdir -p /etc/cni/net.d
cat <<EOF > /etc/cni/net.d/10-weave.conf
{
  "name": "weave",
  "type": "weave-net",
  "hairpinMode": true
}
EOF

## kubelet cri-containerd dropin
cat <<EOF > /etc/systemd/system/kubelet.service.d/20-cri-containerd.conf
[Service]
Environment="KUBELET_SYSTEM_PODS_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///var/run/cri-containerd.sock --pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
EOF

## install cri-containerd
wget -q --https-only --timestamping https://github.com/kubernetes-incubator/cri-containerd/releases/download/v1.0.0-beta.0/cri-containerd-1.0.0-beta.0.linux-amd64.tar.gz
tar xf cri-containerd-1.0.0-beta.0.linux-amd64.tar.gz -C /
rm cri-containerd-1.0.0-beta.0.linux-amd64.tar.gz

systemctl daemon-reload
systemctl enable containerd cri-containerd
systemctl restart containerd cri-containerd kubelet
