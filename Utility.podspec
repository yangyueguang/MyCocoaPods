Pod::Spec.new do |s|
  s.name         = "Utility"
  s.version      = "0.0.8"
  s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
  s.frameworks = 'UIKit','Foundation','sys','CommonCrypto','StoreKit','net','AudioToolbox'
 # s.requires_arc = true
 # s.platform = :ios
 # s.ios.deployment_target = '8.0'
 # s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = 'Category/Utility.{h,m}'
    s.subspec 'Foundation' do |js|
    js.source_files = 'Foundation.h'
  # js.requires_arc = false
    end
 # "GestureNavi/*.{h,m}"
 # s.dependency 'AFNetworking', '~> 3.0' 
end
