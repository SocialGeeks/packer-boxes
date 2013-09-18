# Packer base box configurations  

## Depends on having the following already being installed.   

* [Install Packer](http://www.packer.io/downloads.html)   
* [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)  
* [Install Vagrant](http://www.vagrantup.com/)  

## Build some boxes  

Change into the desired _distro-version_ directory and then run the following command. This will build a base box from VirtualBox and then then turn that into a Vagrant box that can be imported into Vagrant.  

	packer build template.json  

This example will create an Arch Linux x86_64 base vagrant box and then import it into vagrant:

	git clone git@github.com:SocialGeeks/packer-boxes.git  
	cd packer-boxes/archlinux-x86_64
	packer build template.json  
	packer box remove arch virtualbox  
	packer box add arch packer_virtualbox_virtualbox.box  

_Note:_ this particular base box can be used with the [Vagrant file in arch-patsy](https://github.com/SocialGeeks/arch-patsy).  

From there you can use a pre-configured Vagrantfile or just change into an empty directory and issue these commands to create the vagrant instance, from the freebsd-83 box, inside VirtualBox, setup port forwarding to SSH and then login with the vagrant user. From there you have full sudo access to manage the machine.  

	vagrant init arch 
	vagrant up  
	vagrant ssh  

You can destroy a vagrant instance like this:  

	vagrant destroy  

_Note:_ this will destroy all data and configuration changes you made since the vagrant up command was issued.  

