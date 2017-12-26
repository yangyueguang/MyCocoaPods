Pod::Spec.new do |s|
  s.name         = "XCategory"
  s.version      = "0.3.1"
  s.summary      = "这是拓展的集合"
  s.frameworks   = 'UIKit','Foundation','StoreKit','AudioToolbox'
 #s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
 # s.description = "这是拓展的集合"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author       = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files = 'Category'
  s.dependency 'SVProgressHUD'
  s.dependency 'MJRefresh'
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'

end
