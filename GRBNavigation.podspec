Pod::Spec.new do |s|
  s.name         = "GRBNavigation"
  s.version      = "0.0.4"
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
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
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
  s.source_files  = "GRBNavigation"
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
  s.subspec 'VRPlayer' do |ss|
    ss.source_files = 'GRBNavigation/VRPlayer'
  # ss.public_header_files = 'VRPlayer/*.h'
    ss.ios.frameworks = 'MobileCoreServices'
  end


#error
#http://www.jianshu.com/p/e5209ac6ce6b
#http://www.cocoachina.com/ios/20160415/15939.html
#创建github项目=》创建本地podspec文件=》github上release版本=》注册CocoaPods账号=》上传代码到cocoapods=》更新框架版本
#git clone https://github/xx.git
#git add .
#git commit -m “建立代码仓库”
#git push
#pod spec create name ////touch name.podspec
#vim name.podspec
#pod lib lint name.podspec -—allow-warnings
#lib lint —verbose
#更新release。 github
#git tag 1.0.1    #给源代码打版本标签，与podspec文件中version一致即可
#git push --tag
#echo "3.0" > .swift-version.  如果swift版本不对的话s.dependency "SDWebImage", "~> 3.7.1"
#pod trunk register 2829969299@qq.com ‘yangyueguang’ --description=‘薛超’
#Pod trunk me
#pod spec lint -—allow-warnings
#pod trunk push name.podspec -—allow-warnings
#pod repo update
#pod search name


end
