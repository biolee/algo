```bash

sudo apt-get update        # Fetches the list of available updates
sudo apt-get upgrade       # Strictly upgrades the current packages
sudo apt-get dist-upgrade  # Installs updates (new ones)
```


```bash

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo vim /etc/apt/sources.list
deb https://pkg.jenkins.io/debian-stable binary/
sudo apt-get update
sudo apt-get install jenkins






# docker 
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
    
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install docker-ce

sudo usermod -aG docker ${USER}
sudo systemctl status docker


# k8s
sudo snap install conjure-up --classic
conjure-up kubernetes

brew install conjure-up
conjure-up kubernetes


sudo snap install lxd
sudo /snap/bin/lxd init --auto
/snap/bin/lxc network create lxdbr0 ipv4.address=auto ipv4.nat=true ipv6.address=none ipv6.nat=false
```

## Jenkins
1. Configure System
	- gitlab 6vsyQXJmRwdzj9UxWfTM
2. Configure Global Security
3. Global Tool Configuration