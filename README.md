#安装cocoapods
```sudo gem install cocoapods
pod setup
如果失败，运行下面命令
sudo gem update --system
gem sources -l
gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
https://rubygems.org/   https://ruby.taobao.org/
sudo gem install cocoapods
sudo gem update cocoapods
```
# MyCocoaPods
这是我所有自己上传和使用的cocoapods集合

help http://www.cocoachina.com/ios/20160415/15939.html

error http://www.jianshu.com/p/e5209ac6ce6b

# podspec

```
Pod::Spec.new do |s|
s.name         = "GRBNavigationKit"
s.version      = "0.0.5"
s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
s.frameworks = 'UIKit','Foundation'
s.requires_arc = true
s.platform = :ios
s.ios.deployment_target = '8.0'
s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
s.license      = "MIT"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
s.author             = { "yangyueguang" => "邮箱" }
# Or just: s.author    = ""
# s.authors            = { "" => "" }
# s.social_media_url   = "http://twitter.com/"
# s.platform     = :ios
# s.platform     = :ios, "5.0"
#  When using multiple platforms
# s.ios.deployment_target = "5.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"
s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
s.source_files  = "GRBNavigationKit"
#, "GestureNavi/*.{h,m}"
# s.public_header_files = "Classes/**/*.h"
# s.resource  = "icon.png"
# s.resources = "Resources/*.png"
# s.preserve_paths = "FilesToSave", "MoreFilesToSave"
# s.framework  = "SomeFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"
# s.library   = "iconv"
# s.libraries = "iconv", "xml2"
# s.requires_arc = true
# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
# s.dependency "JSONKit", "~> 1.4"
    s.subspec 'JSONKit' do |js|
    js.source_files = 'GRBNavigationKit/JSONKit'
    js.requires_arc = false
    end
    s.subspec 'VRPlayer' do |ss|
    ss.source_files = 'GRBNavigationKit/VRPlayer'
    # ss.public_header_files = 'VRPlayer/*.h'
    ss.ios.frameworks = 'MobileCoreServices'
    end
end
```

#创建github项目=》创建本地podspec文件=》github上release版本=》注册CocoaPods账号=》上传代码到cocoapods=》更新框架版本

```
git clone https://github/xx.git
git add .
git commit -m "建立代码仓库"
git push
git tag 0.0.1
git push --tag //到github上更新release #给源代码打版本标签，与podspec文件中version一致即可
pod spec create name //touch name.podspec
vim name.podspec
echo "3.0" > .swift-version 如果swift版本不对的话s.dependency "SDWebImage", "~> 3.7.1"
pod lib lint name.podspec --allow-warnings
#如果饮用了包涵静态库的.a文件，则需要加上 --use-libraries
pod lib lint --verbose
pod trunk register 邮箱 'yangyueguang' -description='薛超'
pod trunk me
pod spec lint --allow-warnings
pod trunk COMMAND
pod trunk push name.podspec  --allow-warnings
pod repo update
pod search name
```
# 更新内容
```
pod 'BaseFile'
pod 'XCategory'
pod 'XExtension'
pod 'XCarryOn'
pod 'XWechartSDK'
#pod 'XAlipaySDK'
```
# RepositoryBranch
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
