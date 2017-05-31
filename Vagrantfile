# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT

echo "### Starting Vagrant provisioning script ###"
echo $USER
echo
ls -la /vagrant/

cat /vagrant/.ssh_key >> .ssh/authorized_keys
echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/${USER}

# Change Time Zone
# dpkg-reconfigure tzdata
sudo timedatectl set-timezone Europe/Warsaw

# ======================================
# Docker
# https://docs.docker.com/engine/installation/linux/ubuntulinux/#/install
# ======================================
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get -y install docker-engine
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

SCRIPT

Vagrant.configure(2) do |config|
    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
        v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    end
    config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "vagrant"
    config.vm.provision "shell", inline: $script, privileged: false
    config.vm.network "private_network", ip: "10.0.0.100"
    config.vm.synced_folder ".", "/vagrant",
        id: "project"

end
