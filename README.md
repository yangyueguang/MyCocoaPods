# MyCocoaPods
这是我所有自己上传和使用的cocoapods集合
http://www.cocoachina.com/ios/20160415/15939.html
创建podspec文件
在Github上创建release版本
注册CocoaPods账号
上传代码到CocoaPods
检验是否上传成功
更新框架版本
```
git clone https://git.coding.net/annlmj/aaa.git 
git add .
git commit -m "建立代码仓库"
git push
git tag 0.0.1
git push --tag //到github上更新release
pod spec create name
///touch name.podspec
vim name.podspec
pod lib lint name.podspec -allow-warnings
pod lib lint --verbose
pod trunk register 2829969299@qq.com 'yangyueguang' -description='薛超'
pod trunk me
pod spec lint --allow-warnings
pod trunk COMMAND
pod trunk push name.podspec  --allow-warnings
pod repo update
```

手势返回导航控制器，首次支持pod安装 pod ‘GRBNavigation’<br>
网上的JSONKit导入项目中经常报21个错，因此我修复了错误之后把它以XJSONKit的名字上传到podspec上了，以后可以用 
`pod 'XJSONKit'`
来代替
`pod 'JSONKit' `


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
