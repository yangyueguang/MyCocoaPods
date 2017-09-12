Pod::Spec.new do |s|
  s.name         = "BaseFillTableViewController"
  s.version      = "0.1.2"
  s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
  s.frameworks = 'UIKit','Foundation','QuartzCore'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "BaseFile/BaseFillTableViewController.{h,m}"
   s.dependency 'MJRefresh','~>3.1.0'
   s.dependency 'AFNetworking','~>3.0'
   s.dependency 'SDWebImage'
   s.dependency 'SVProgressHUD','~>0.9'
 #  s.dependency 'NSString+expanded'
end
