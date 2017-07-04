# MyCocoaPods
这是我所有自己上传和使用的cocoapods集合


# 1  RepositoryBranch
## 这是只克隆一个仓库中的某个文件夹或某个分支到本地进行修改并上传的说明。
```
Desktop super$ mkdir devops
Desktop super$ cd devops/
Desktop super$ git init    #初始化空库 <br>
Desktop super$ git remote add -f origin https://github.com/yangyueguang/RepositoryBranch.git   #拉取remote的all objects信息
```
>\*Updating origin<br>
remote: Counting objects: 70, done.<br>
remote: Compressing objects: 100% (66/66), done.<br>
remote: Total 70 (delta 15), reused 0 (delta 0)<br>
Unpacking objects: 100% (70/70), done.<br>
From https://github.com/yangyueguang/RepositoryBranch<br>
\* [new branch]      master     -> origin/master<br>
```
Desktop super$ git config core.sparsecheckout true   #开启sparse clone
Desktop super$ echo "devops/" >> .git/info/sparse-checkout   #设置需要pull的目录，*表示所有，!表示匹配相反的
Desktop super$ echo "another/sub/tree" >> .git/info/sparse-checkout
Desktop super$ more .git/info/sparse-checkout
Desktop super$ git pull origin master  #更新
```
>From https://github.com/yangyueguang/RepositoryBranch<br>
\* branch            master     -> FETCH_HEAD
```
Desktop super$ git add .
Desktop super$ git commit -m "change"
Desktop super$ git push
```
