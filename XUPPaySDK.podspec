Pod::Spec.new do |s|
  s.name         = "XUPPaySDK"
  s.version      = "0.3.0"
  s.summary      = "这是银联支付集合."
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是银联支付的集合。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "XUPPaySDK"
  s.vendored_libraries = 'XUPPaySDK/libPaymentControl.a'
  s.libraries = 'c++','z'
  # s.dependency 'AFNetworking','~>3.0'
end
