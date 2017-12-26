Pod::Spec.new do |s|
  s.name         = "BaseCollectionView"
  s.version      = "0.3.1"
  s.summary      = "这是基本的集合视图"
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是基本的集合视图"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author       = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = 'BaseFile/BaseCollectionView'
  s.dependency 'MJRefresh', '~> 3.1.0'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'SDWebImage'
  s.dependency 'SVProgressHUD', '~> 2.2'
end
