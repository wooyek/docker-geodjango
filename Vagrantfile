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
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common python

source /etc/os-release
echo $UBUNTU_CODENAME

# ======================================
# Docker
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce
# ======================================

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USER

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
