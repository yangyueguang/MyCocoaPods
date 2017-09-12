Pod::Spec.new do |s|
  s.name         = "Utility"
  s.version      = "0.1.0"
  s.summary      = "这是工具类"
  s.frameworks = 'UIKit','Foundation','sys','CommonCrypto','StoreKit','net','AudioToolbox'
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = 'Category/Utility.{h,m}'
    s.subspec 'Foundation' do |js|
    js.source_files = 'Foundation.h'
    end
  s.dependency 'AFNetworking' 
  s.dependency 'NSString+expanded'
end
