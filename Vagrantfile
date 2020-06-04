$script_docker = <<-SCRIPT
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2 && \
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
  sudo yum install -y docker-ce docker-ce-cli containerd.io && \
  systemctl enable docker && \
  systemctl start docker
SCRIPT

Vagrant.configure("2") do |config|
   #CHOOSE THE VM BOX
   config.vm.box = "centos/7"
   
   #CREATE MOODLE VM
   config.vm.define "moodle" do |moodle|
      #SET NETWORK
      moodle.vm.network "private_network", ip: "192.168.10.2"
      moodle.vm.network "public_network"
      #SET VM HARDWARE CONFIG
      moodle.vm.provider "virtualbox" do |vb|
         vb.memory = 2048
         vb.cpus = 4
         vb.name = "moodle"
      end
      #INSTALL DOCKER
      moodle.vm.provision "shell", inline: $script_docker
      #INSTALL ANSIBLE
      moodle.vm.provision "shell",
         inline: "sudo yum install -y epel-release -y && \
         sudo yum install -y ansible python python-pip httpd && \
         sudo pip install docker-py"
      #RUN ANSIBLE PLAYBOOK
      moodle.vm.provision "shell",
         inline: "ansible-playbook /vagrant/docker-moodle.yml \
         -e 'host=localhost env=dev user=admin pass=MoodleAdmin mail=moodle@yourdomain.com url=moodle.yourdomain.com dbport=3306' -t deploy"
   end  
end
