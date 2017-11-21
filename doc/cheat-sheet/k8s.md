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

# k8s

https://github.com/feiskyer/kubernetes-handbook/blob/master/SUMMARY.md

## pod
### 私有镜像
```bash
kubectl create secret docker-registry biolee_regsecret --docker-server=<your-registry-server> \
	--docker-username=<your-name> \
	--docker-password=<your-pword> \
	--docker-email=<your-email>
```
```yaml
apiVersion: v1
kind: Pod
metadata:
	name: private-reg
spec:
	containers:
	- name: private-reg-container
		image: <your-private-image>
		imagePullSecrets:
			- name: biolee_regsecret
```
### RestartPoliy 本地重启
- Always：只要退出就重启
- OnFailure：失败退出（exit code不等于0）时重启
- Never：只要退出就不再重启
### 环境变量
- HOSTNAME

### ImagePullPolicy
- Always：不管镜像是否存在都会进行一次拉取
- Never：不管镜像是否存在都不会进行拉取
- IfNotPresent：只有镜像不存在时，才会进行镜像拉取

注意：

- 默认为IfNotPresent，但:latest标签的镜像默认为Always。
- 拉取镜像时docker会进行校验，如果镜像中的MD5码没有变，则不会拉取镜像数据。
- 生产环境中应该尽量避免使用:latest标签，而开发环境中可以借助:latest标签自动拉取最新的镜像。

# docker 
    
## Resize disk space for docker vm
    
docker-machine create --driver virtualbox --virtualbox-disk-size "40000" default
 
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