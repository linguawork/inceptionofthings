Vagrant.configure("2") do |config|
  config.vm.define "areggieS" do |server|
    server.vm.box = "ubuntu/jammy64"
    server.vm.hostname = "areggieS"
    server.vm.network "private_network", ip: "192.168.56.110"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    server.vm.provision "shell", path: "scripts/server.sh"
   end

  config.vm.define "areggieSW" do |worker|
    worker.vm.box = "ubuntu/jammy64"
    worker.vm.hostname = "areggieSW"
    worker.vm.network "private_network", ip: "192.168.56.111"
    worker.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    worker.vm.provision "shell", path: "scripts/worker.sh"
  end
end


