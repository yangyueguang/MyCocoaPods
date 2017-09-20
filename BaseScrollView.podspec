Pod::Spec.new do |s|
  s.name         = "BaseScrollView"
  s.version      = "0.1.8"
  s.summary      = "这是基本的滚动视图，内含许多滚动的封装。"
  s.frameworks   = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是基本的滚动视图，内含许多滚动的封装。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author       = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "BaseFile/BaseScrollView.{h,m}"
   s.dependency 'MJRefresh'
   s.dependency 'AFNetworking'
   s.dependency 'SDWebImage'
   s.dependency 'SVProgressHUD'
end
