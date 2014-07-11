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
	vagrant box add archlinux-x86_64 packer_virtualbox_virtualbox.box  

From there you can use a pre-configured Vagrantfile or just change into an empty directory and use the "vagrant init <boxname>" command to create a new Vagrantfile.  Then use these commands to create the vagrant instance inside VirtualBox, setup port forwarding to SSH and then login with the vagrant user. From there you have full sudo access to manage the machine.  

	vagrant up  
	vagrant ssh  

You can destroy a vagrant instance like this:  

	vagrant destroy  

_Note:_ this will destroy all data and configuration changes you made since the vagrant up command was issued.  

## Windows users  

Thanks to [ktBoneFish](https://github.com/ktbonefish) for testing this on Windows.  

### Fix path for VirtualBox   

First add the virtualbox path to the %path% variable. Mine for example was: C:\Program Files\Oracle\VirtualBox

### Fix line endings  

Next you need to fix github to not change line endings:  
open up github command line (has to be githubs) and run the following line to make sure it doesn't auto set windows newlines.

	git config --global core.autocrlf false  

After both of these are set, then download the github repo, and start the build.  

### Packer build  
You may have trouble running packer from a different folder location, you need to run the packer with direct file location of the packer executable, like follows (what i used in my case)  

	K:\github\packer\packer build template.jason  

### SSH steps  

After everything is setup, you can then SSH to box after you start it up with the commands with the vagrant commands. Depending what SSH client you know, you will have to import or put the private key the "vagrant ssh" command created to the ssh client. I used githubs ssh so i had to add the private keys in with the following command:  

	add-sshkey c:\users\bonefish\.vagrant.d\insecure\private_key  

Then connected with the following command in the github CLI  

	ssh vagrant@127.0.0.1 -p 2222  

