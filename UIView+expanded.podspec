Pod::Spec.new do |s|
  s.name         = "UIView+expanded"
  s.version      = "0.0.7"
  s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = 'Category/UIView+expanded.{h,m}'
#, "GestureNavi/*.{h,m}"
  # s.dependency "JSONKit", "~> 1.4"
end
