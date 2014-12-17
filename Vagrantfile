VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  	config.vm.define "centos-build" do |centos|
	  centos.vm.box = "centos-build"
	  centos.vm.synced_folder ".", "/home/vagrant/working/"
	  centos.vm.provider "virtualbox" do |v|
	    v.memory = 4096
	    v.cpus = 4
	  end
    end
    config.vm.define "centos-test" do |centos1|
	  centos1.vm.box = "centos-test"
	  centos1.vm.synced_folder ".", "/home/vagrant/working/"
	  centos1.vm.provider "virtualbox" do |v|
	    v.memory = 1024
	    v.cpus = 1
	  end
    end
end