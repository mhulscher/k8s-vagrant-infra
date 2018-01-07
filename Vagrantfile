$masters = 1
$workers = 2
$runtime = "cri-containerd" # or 'docker'

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.vm.provision "shell", path: "provision-base.sh"
  config.vm.provision "shell", path: "provision-#{$runtime}.sh"

  config.vm.provider "virtualbox" do |v|
    v.cpus   = 2
    v.memory = 1024
  end

  (1..$masters).each do |n|
    config.vm.define "k8s-master#{n}" do |master|
      master.vm.hostname = "k8s-master#{n}"
      master.vm.network "private_network", ip: "10.0.0.1#{n}"
      master.vm.provision :shell, :inline => "sed 's/127.0.0.1.*k8s-master#{n}/10.0.0.1#{n} k8s-master#{n}/' -i /etc/hosts"

      master.vm.provider "virtualbox" do |v|
        v.memory = 2048
      end
    end
  end

  (1..$workers).each do |n|
    config.vm.define "k8s-worker#{n}" do |worker|
      worker.vm.hostname = "k8s-worker#{n}"
      worker.vm.network "private_network", ip: "10.0.0.2#{n}"
      worker.vm.provision :shell, :inline => "sed 's/127.0.0.1.*k8s-worker#{n}/10.0.0.2#{n} k8s-worker#{n}/' -i /etc/hosts"
    end
  end
end
