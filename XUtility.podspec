Pod::Spec.new do |s|
  s.name         = "XUtility"
  s.version      = "0.1.1"
  s.summary      = "这是工具类"
  s.frameworks = 'UIKit','Foundation','JavaScriptCore','StoreKit','AudioToolbox'
#,'CommonCrypto'
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.platform = :ios  
  s.ios.deployment_target = '8.0'
 # s.platform = :ios
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = 'Category/Utility.{h,m}'
   # s.subspec 'Foundation' do |js|
  #  js.source_files = 'Foundation.h'
   # end
  s.dependency 'AFNetworking' 
  s.dependency 'NSString+expanded'
end
