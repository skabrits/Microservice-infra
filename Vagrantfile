WORKER_NUM=2
IP_BASE="192.168.56."
IP_START=2

Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"
  config.vbguest.auto_update = false
  
  config.vm.provision "shell", env: {"IP_BASE" => IP_BASE, "WORKER_NUM" => WORKER_NUM, "IP_START" => IP_START}, inline: <<-SHELL
      echo "$IP_BASE$IP_START master-01" >> /etc/hosts

      for i in `seq 1 $WORKER_NUM`
      do
        echo "$IP_BASE$((IP_START+i)) worker-0$((i))" >> /etc/hosts
      done
  SHELL
  
  config.vm.provision "shell", path: "scripts/common.sh"
    
  config.vm.define "master-01" do |master|
    master.vm.hostname = "master-01"
    master.vm.network "private_network", ip: IP_BASE + "#{IP_START}"
    master.vm.provision "shell", path: "scripts/master.sh"
    master.vm.provision "shell", path: "scripts/master_finish.sh"
    master.vm.provision "shell", path: "scripts/deploy.sh"

    master.vm.provider "virtualbox" do |v|
      v.name = "master-01"
      v.memory = 6144
      v.cpus = 2
    end
  end

  (1..WORKER_NUM).each do |i|
    
    config.vm.define "worker-0#{i}" do |worker|
      worker.vm.hostname = "worker-0#{i}"
      worker.vm.network "private_network", ip: IP_BASE + "#{IP_START+i}"
      worker.vm.provision "shell", path: "scripts/worker.sh"
	worker.vm.provider "virtualbox" do |v|
        v.name = "worker-0#{i}"
        v.memory = 8192
        v.cpus = 2
    	end
    end
  end
end
