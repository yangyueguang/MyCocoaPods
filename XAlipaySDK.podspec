Pod::Spec.new do |s|
  s.name         = "XAlipaySDK"
  s.version      = "0.3.2"
  s.summary      = "这是支付宝支付集合."
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是支付宝支付的集合。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }  
  s.resources = 'XAlipaySDK/AlipaySDK.bundle'
  s.vendored_frameworks = 'XAlipaySDK/AlipaySDK.framework'
  s.vendored_libraries = 'XAlipaySDK/libcrypto.a','XAlipaySDK/libssl.a'
  s.libraries = 'c++','z','stdc'
  s.frameworks = 'CoreTelephony', 'SystemConfiguration','UIKit','Foundation','QuartzCore','CoreText','CoreGraphics','CoreMotion','CFNetwork'
  s.source_files  = 'XAlipaySDK'
 # s.dependency 'AliPaySDK-Pod'
  s.subspec 'openssl' do |cv|
         cv.source_files = 'XAlipaySDK/openssl'
         cv.requires_arc = true
        end
        s.subspec 'Util' do |tv|
        tv.dependency 'XAlipaySDK/openssl'
        tv.source_files = 'XAlipaySDK/Util'
        tv.requires_arc = true
        end

end
