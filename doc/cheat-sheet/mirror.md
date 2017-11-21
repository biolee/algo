https://mirrors.ustc.edu.cn/
https://mirrors.tuna.tsinghua.edu.cn/

# java
## alibaba maven

[${HOME}/.m2/setting.xml](../../configs/m2/setting.xml)

# rust 

```bash
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
```

$HOME/.cargo/config

```yaml
[source.crates-io]
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
```

# python

## command line
`pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package`
## global
```yaml
// ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```
conda config --add channels 'https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/'
conda config --set show_channel_urls yes

# tensorflow

https://mirrors.tuna.tsinghua.edu.cn/help/tensorflow/

# yum

yum install epel-release

当前tuna已经在epel的官方镜像列表里，所以不需要其他配置，mirrorlist机制就能让你的服务器就近使用tuna的镜像
如果你想强制 你的服务器使用tuna的镜像，可以修改/etc/yum.repos.d/epel.repo，将baseurl开头的行取消注释（删掉#），并注释mirrorlist 开头的行（在头部加一个#）。
接下来，把这个文件里的http://download.fedoraproject.org/pub替换成https://mirrors.tuna.tsinghua.edu.cn即可。

# Homebrew
```bash
# ustc
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

# tuna
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
cd "$(brew --repo)"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
brew update
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-science"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-science.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-python"
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-python.git
brew update

# 重置为官方地址
cd "$(brew --repo)"

git remote set-url origin https://github.com/Homebrew/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://github.com/Homebrew/homebrew-core.git
cd "$(brew --repo)"/Library/Taps/caskroom/homebrew-cask
git remote set-url origin https://github.com/caskroom/homebrew-cask
brew update
```

# node

## yarn
yarn config get registry
yarn config set registry https://registry.npm.taobao.org
yarn config set registry https://registry.npmjs.org

## npm
npm config get registry
npm config set registry https://registry.npm.taobao.org
npm config set registry=https://registry.npmjs.org

[${HOME}/.npmrc](../../configs/npmrc)

## Electron Mirror of China
```bash
ELECTRON_MIRROR="https://npm.taobao.org/mirrors/electron/"
sass_binary_site=https://npm.taobao.org/mirrors/node-sass/

phantomjs_cdnurl=https://npm.taobao.org/mirrors/phantomjs/
electron_mirror=https://npm.taobao.org/mirrors/electron/
registry=http://registry.npmjs.org

init-author-name=liyanan
init-author-email=liyananfamily@gmail.com
```
