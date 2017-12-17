# Installation

## Master
* `vagrant up`
* `vagrant ssh k8s-master1 -- sudo kubeadm init --apiserver-advertise-address 10.0.0.11`
* `vagrant ssh k8s-master1 -- sudo cat /etc/kubernetes/admin.conf > kubeconfig.yaml`
* `kubectl --kubeconfig kubeconfig.yaml apply -f weave-net.yaml`
* `kubectl --kubeconfig kubeconfig.yaml get nodes -o wide`

## Worker
* `vagrant ssh k8s-worker1 -- sudo kubeadm join ...`
