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
