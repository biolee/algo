# mac

```bash
brew cask install virtualbox
#brew cask install vagrant
#brew cask install vagrant-manager

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
brew install kubectl

kubectl cluster-info

# install nimikube https://github.com/kubernetes/minikube/releases
# mac
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.3/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/


minikube start
minikube stop


# Kubectl Autocomplete
https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/
```


# docker 

mirror: `registry.docker-cn.com/library/`
```bash
docker volume ls -qf dangling=true | xargs docker volume rm

```

# Docker - How to cleanup (unused) resources

Once in a while, you may need to cleanup resources (containers, volumes, images, networks) ...
    
## delete volumes
    
    // see: https://github.com/chadoe/docker-cleanup-volumes
    
    $ docker volume rm $(docker volume ls -qf dangling=true)
    $ docker volume ls -qf dangling=true | xargs -r docker volume rm
    
## delete networks

    $ docker network ls  
    $ docker network ls | grep "bridge"   
    $ docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
    
## remove docker images
    
    // see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images
    
    $ docker images
    $ docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
    
    $ docker images | grep "none"
    $ docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')

## remove docker containers

    // see: http://stackoverflow.com/questions/32723111/how-to-remove-old-and-unused-docker-images
    
    $ docker ps
    $ docker ps -a
    $ docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    
## Resize disk space for docker vm
    
    $ docker-machine create --driver virtualbox --virtualbox-disk-size "40000" default
 
 
 add-apt-repository ppa:ubuntu-lxc/lxd-stable
 apt-get update
 apt-get dist-upgrade
 apt-get install lxd
 
 # network
 查看docker容器虚拟ip
 `docker inspect --format '{{ .NetworkSettings.IPAddress }}' [容器ID]`
 宿主机IP `与容器同网段，而且是XXX.XXX.XXX.1`
 docker network ls
 docker network inspect bridge
 
 docker run 创建 Docker 容器时，可以用 –net 选项指定容器的网络模式。
 host模式 : 使用 –net=host 指定。与宿主机共享网络，此时容器没有使用网络的namespace，宿主机的所有设备，如Dbus会暴露到容器中，因此存在安全隐患。
 container模式 : 使用 –net=container:NAME_or_ID 指定。指定与某个容器实例共享网络。
 none模式 : 使用 –net=none 指定。不设置网络，相当于容器内没有配置网卡，用户可以手动配置。
 bridge模式 : 使用 –net=bridge 指定，默认设置。此时docker引擎会创建一个veth对，一端连接到容器实例并命名为eth0，另一端连接到指定的网桥中（比如docker0），因此同在一个主机的容器实例由于连接在同一个网桥中，它们能够互相通信。容器创建时还会自动创建一条SNAT规则，用于容器与外部通信时。如果用户使用了-p或者-Pe端口端口，还会创建对应的端口映射规则。
 
 
 Docker 中国官方镜像加速
 
 docker pull registry.docker-cn.com/myname/myrepo:mytag
 
 /etc/docker/daemon.json 文件并添加上 registry-mirrors 键值。                    
                     
                         
 {
   "registry-mirrors": ["https://registry.docker-cn.com"]
 }