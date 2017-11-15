# 常用工作流
```bash
## 开始一个git项目
mkdir my_git_project_name && cd my_git_project_name && git init
### OR 
git clone https://git.com/myname/my_git_project_name

## 修改

## 提交
git status
git add .
git commit -m 'describe what you do'
git push https://git.com/myname/my_git_project_name master

## 获取远程更新
git pull https://git.com/myname/my_git_project_name master
```


# 基本操作
## 仓库生成

```bash
# 将当前目录，或者指定的DIR-NAME目录初始化为仓库
git init [DIR-NAME] 

# 将远端工程放入当前目录，或者重命名为指定的DIR-NAME的目录
git clone REPOSITORY-URL [DIR-NAME] 
```

## 分支操作

```bash
# 显示本地分支
git branch 
# -r 显示远程分支 
git branch -r
# -a 显示所有分支
git branch -a

# 以当前分支为基础创建一个分支
git branch NEW-BRANCH 

# 以BASE-BRANCH为基础创建一个分支
git branch NEW-BRANCH BASE-BRANCH 

# 以当前分支为基础创建一个分支
git checkout -b NEW-BRENCH 

# 以BASE-BRANCH为基础创建一个分支
git checkout -b NEW-BRANCH BASE-BRANCH 

# 切换到分支
git checkout BRANCH-NAME 

# 删除BRANCH-NAME指定的分支（如果要删除的分支有内容未合并到当前分支，不能删除） -D表示无条件删除
git branch -d BRANCH-NAME 
```


## remote

```bash
# repository url管理, 建议主要REMOTE_NAME为origin
git remote add [REMOTE_NAME REPOSITORY-URL]
git remote rename [REMOTE_NAME_OLD REMOTE_NAME_NEW]
git remote remove [REMOTE_NAME]

# 取回远端分支内容
git fetch [REPOSITORY-URL REMOTE-BRANCH]
# OR
git fetch [REMOTE_NAME REMOTE-BRANCH]


# 将ANOTHER-BRANCH的内容合并到当前分支
git merge ANOTHER-BRANCH

# 将远端分支的内容取回并尝试合并
git pull [REPOSITORY-URL REMOTE-BRANCH:LOCAL-BRANCH] 

# 使用合并工具进行合并
git mergetool 
```



### 内容提交
```bash
ssh-keygen -t rsa
copy ~/.ssh/id_rsa.pub to git web site

# 查看当前改动提交状态
git status  

# 对比工作区和暂存区，--cached 为比较暂存区和HEAD
git diff 

# 添加所有改动到git 跟踪，指定FILEPATH则只添加指定内容
git add . 

# 提交所有改动到本地仓库
git commit -m "commit log" 
# --amend 表示调整上一次提交
git commit --amend -m "commit log" 



# 推动本地仓库信息到远端仓库
git push [REPOSITORY-URL LOCAL-BRANCH:REMOTE-BRANCH] 
# OR 
git push [REMOTE_NAME LOCAL-BRANCH:REMOTE-BRANCH] 
```

## 实践
```bash
# 当前工作未完成，临时切换到其他分支

# 暂存当前未提交的内容
git stash 

# 暂存内容并提供描述信息
git stash save "stash log" 

# 将最后一个暂存的内容取出
git stash pop 

# 查看所有暂存
git stash list 

# 取出一个特定的暂存
git stash pop [stash@{n}] 

## 查找某处变更是哪次提交生成的（bug是谁在什么时候写的~）

## 方法一 查看m到n行之间的最后一次变更的信息
git blame FILE-NAME -L m,n 

## 方法二 查看文件的m到n行之间的变化

git log -L m,n:FILE-NAME     

## 方法三

### 开始一个二分查找
git bisect start 

### 设置一个已经出问题的版本
git bisect bad COMMIT-ID 

### 设置一个没有问题的版本
git bisect good COMMIT-ID 

### 持续的给结果，最后会定位到一个版本，结果跟方法二的类似
git bisect good|bad 

### 方法四 查找关键信息的变更，这里给出的是一个大致信息，比如是在其他分支做出的改动
git show :/KEY-WORD 
```


# 不可逆操作

修改历史
* 版本信息的引用
    * 相对一个版本 比如 HEAD^
* 相对N个版本 比如 HEAD@{10}
    * 相对N个版本 比如 HEAD~10
* 相对N个版本 比如 HEAD@{5}^~5
* 版本区间
    * A..B, A不可达&&B可达的的范围，如果是同一条主线上，则是前开后闭区间，否则视情况而定
* ^A B 等同于 A..B
    * B —not A 等同于 A..B
* A…B A可达&&B可达除掉AB都可达的范围，前后闭区间
修改已经提交的log信息


```bash
# 修改上次的log
git commit --amend
## 谨慎谨慎，只有提交了远端仓库才需要这个
git push -f 


# 合并上几次的log,原来五条
## 在当前分支回退五个版本的提交历史
git reset HEAD^^~3 
git commit -m "combined commit" 
## 谨慎谨慎，只有提交了远端仓库才需要这个
git push -f 

# 修改提交内容的历史
# * 现有的版本A,B,C,D,E
# * 删掉C的提交内容

## 使用revert 简单，但会增加一次提交，而且C原来的提交也会留在历史中
git revert C 

## 使用rebase
git rebase -i B  删掉想要删掉的C提交,然后保存

## 使用cherry-pick
###先切到D之前的提交
git checkout B 
### 将后面的提交再拉进来
git cherry-pick C..E 
git checkout -b xxx 放入新的分支中


# 修改commit历史
git rebase -i HEAD~n
```

# gitlab 
[depoly with docker](https://docs.gitlab.com/omnibus/docker/README.html)
[configure](https://docs.gitlab.com/omnibus/README.html)
