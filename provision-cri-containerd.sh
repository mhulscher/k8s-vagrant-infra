#!/bin/bash

set -eufo pipefail

CRI_CONTAINERD_VERSION=1.0.0-beta.1

# Install cri-containerd as runtime

## enable forwarding
echo net.ipv4.conf.all.forwarding=1 > /etc/sysctl.d/90-forwarding.conf
systemctl restart systemd-sysctl

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
wget -q --https-only --timestamping https://github.com/containerd/cri-containerd/releases/download/v${CRI_CONTAINERD_VERSION}/cri-containerd-${CRI_CONTAINERD_VERSION}.linux-amd64.tar.gz
tar xf cri-containerd-${CRI_CONTAINERD_VERSION}.linux-amd64.tar.gz -C /
rm cri-containerd-${CRI_CONTAINERD_VERSION}.linux-amd64.tar.gz

systemctl daemon-reload
systemctl enable containerd cri-containerd
systemctl restart containerd cri-containerd kubelet
