# Installation

## Master
* `vagrant up`
* for cri-containerd: `vagrant ssh k8s-master1 -- sudo kubeadm init --cri-socket /var/run/cri-containerd.sock --ignore-preflight-errors=FileContent--proc-sys-net-bridge-bridge-nf-call-iptables --apiserver-advertise-address 10.0.0.11`
* for docker: `vagrant ssh k8s-master1 -- sudo kubeadm init --apiserver-advertise-address 10.0.0.11`
* `vagrant ssh k8s-master1 -- sudo cat /etc/kubernetes/admin.conf > kubeconfig.yaml`
* `kubectl --kubeconfig kubeconfig.yaml apply -f weave-net.yaml`
* `kubectl --kubeconfig kubeconfig.yaml get nodes -o wide`

## Worker
* for cri-containerd: `vagrant ssh k8s-worker1 -- sudo kubeadm join --cri-socket /var/run/cri-containerd.sock --ignore-preflight-errors=FileContent--proc-sys-net-bridge-bridge-nf-call-iptables ...`
* for docker: `vagrant ssh k8s-worker1 -- sudo kubeadm join ...`
