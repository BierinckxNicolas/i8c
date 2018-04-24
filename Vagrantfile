# -*- mode: ruby -*-
# vi: set ft=ruby :

prerequisite_missing = false

# The centos/7 box doesn't contain the VirtualBox Guest Additions. Use the vagrant-vbguest plugin to install them automatically.
# This functionality is required to automatically sync the /vagrant folder between host and guest.
unless Vagrant.has_plugin?("vagrant-vbguest")
  puts "Vagrant plugin 'vagrant-vbguest' missing! Install it first by typing 'vagrant plugin install vagrant-vbguest'"
  prerequisite_missing = true
end

# Reload the box after provisioning to enable automatic syncing of /vagrant folder and other stuff
unless Vagrant.has_plugin?("vagrant-reload")
  puts "Vagrant plugin 'vagrant-reload' missing! Install it first by typing 'vagrant plugin install vagrant-reload'"
  prerequisite_missing = true
end

if prerequisite_missing
  exit
end

# For Puppet v4.0 and higher add the modulepath option (environment support)
# puppet module install puppetlabs/stdlib --modulepath /etc/puppet/modules
$puppet_lib_install_script = <<EOF
  mkdir -p /etc/puppet/modules;
  if [ ! -d /etc/puppet/modules/stdlib ]; then
    puppet module install puppetlabs/stdlib
  fi
EOF



# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
  vb.gui = true
  # Adapt the memory and CPU settings below to the specs of your laptop
  vb.memory = "4096"
  vb.cpus = "2"
  vb.name = "bootcamp02"
  vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]

  # Override the rsync type in the Vagrantfile of the centos/7 box
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder ".", "/vagrant", fsnotify: true
end


# Change timezone to Brussels
config.vm.provision "timezone", privileged: true, type: "shell", inline: "timedatectl set-timezone Europe/Brussels"

# Install GNOME desktop, also installs a lot of other utilities such as wget, firefox, packagekit, JDK 8,...
config.vm.provision "desktop", privileged: true, type: "shell", inline: "echo 'installing desktop ...' && yum -y groupinstall 'GNOME Desktop' 'Graphical Administration Tools' && systemctl set-default graphical.target && systemctl start graphical.target && echo 'desktop installed!'"

# Disable automatic updates, this may conflict with later yum installation commands
config.vm.provision "autoupdate-off", privileged: true, type: "shell", inline: "echo 'disabling packagekit ...' && systemctl stop packagekit.service && systemctl mask packagekit.service && echo 'packagekit disabled!'"

# Change keyboard to Belgian layout, remove/update if you use a different keyboard layout
# The keyboard layout can also be selected upon first login in GNOME
config.vm.provision "keyboard", privileged: true, type: "shell", inline: "localectl set-x11-keymap be"

# Install development tools. Note that JDK 8 will be installed as one of the Maven dependencies
config.vm.provision "devtools", privileged: true, type: "shell", inline: "yum install -y git maven"

# Install Eclipse installer
config.vm.provision "eclipseInstaller", privileged: false, type: "shell", path: "installEclipseInstaller.sh"


# disable the jre that is installed with SOAP-UI, it's an outdated 1.7 version that can cause SSL handshake failures.
config.vm.provision "soapui", privileged: false, type: "shell", inline:  "echo 'installing SoapUI...' && wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-x64-5.4.0.sh && chmod u+x SoapUI-x64-5.4.0.sh && ./SoapUI-x64-5.4.0.sh -q && mv /home/vagrant/SmartBear/SoapUI-5.4.0/jre /home/vagrant/SmartBear/SoapUI-5.4.0/jre.disabled && echo 'SoapUI installed!'"


# Install postgresql. Check instructions on https://www.postgresql.org/download/linux/redhat/
# Creates a user vagrant with password vagrant.
config.vm.provision "postgresql", privileged: true, type: "shell", path: "installPostgresql.sh"

# Install Docker
config.vm.provision "docker"

# Install the Jenkins server as a docker container
# Make sure the guest vm has been reloaded so that the /vagrant folder is synced with the host
config.vm.provision "jenkinsContainer", type: "docker" do |docker|
  docker.run "bootcamp-jenkins",
  image: "jenkinsci/blueocean",
  args: "-u root -p 8081:8080 -v /vagrant/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v /vagrant:/home --env JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
end

# Install WSO2 API Manager using puppet scripts provided by WSO2 at https://github.com/wso2/puppet-apim
 # Don't use latest puppet version = 5.3.3 yet, causes problems with environments features introduced in Puppet version 4
 config.puppet_install.puppet_version = "3.8.7"
 #config.puppet_install.puppet_version = :latest

 config.vm.provision "puppetlib",type: "shell" do |shell|
   shell.inline = $puppet_lib_install_script
 end

 # TODO: automate execution of setupWSO2PuppetModules.sh before continuing with the next sections
 # Maybe project's setup.sh file is a better place to include this?
 config.vm.provision "WSO2IS", type: "puppet" do |puppet|
   puppet.manifest_file = "site.pp"
   puppet.manifests_path = "puppet_home/manifests"
   puppet.module_path = "puppet_home/modules"
   puppet.hiera_config_path = "puppet_home/hiera.yaml"
   puppet.options = %w(--verbose --debug --trace)
   puppet.facter = {
     "product_name" => "wso2is_prepacked",
     "product_version" => "5.3.0",
     "product_profile" => "default",
     "environment" => "dev",
     "platform" => "default",
     "use_hieradata" => "true",
     "pattern" => "pattern-1"
   }
 end
 config.vm.provision "WSO2APIM", type: "puppet" do |puppet|
   puppet.manifest_file = "site.pp"
   puppet.manifests_path = "puppet_home/manifests"
   puppet.module_path = "puppet_home/modules"
   puppet.hiera_config_path = "puppet_home/hiera.yaml"
   puppet.options = %w(--verbose --debug --trace)
   puppet.facter = {
     "product_name" => "wso2am_runtime",
     "product_version" => "2.1.0",
     "product_profile" => "default",
     "environment" => "dev",
     "platform" => "default",
     "use_hieradata" => "true",
     "pattern" => "pattern-7"
   }
 end

# Installs React and its dependencies (Node, Npm, Yarn, create-react-app)
config.vm.provision "react", run: "always", privileged: false, type: "shell", path: "installReact.sh"


# Reload to enable the VirtualBox Guest Additions and keyboard change
# Use vagrant reload, "shutdown -r" from the guest command line is not sufficient
config.vm.provision :reload



  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

end
