Pod::Spec.new do |s|
  s.name         = "AlipaySDK"
  s.version      = "0.2.7"
  s.summary      = "这是支付宝支付集合."
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是支付宝支付的集合。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  # s.authors            = { "" => "" }
  # s.social_media_url   = "http://twitter.com/"
  # s.platform     = :ios
  # s.platform     = :ios, "5.0"
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
 # s.vendored_frameworks = 'AlipaySDK/AlipaySDK.framework'  
  s.source_files  = "AlipaySDK"
  	 s.subspec 'openssl' do |cv|
   	 cv.source_files = 'AlipaySDK/openssl'
  	 cv.requires_arc = true
       	end
	s.subspec 'util' do |tv|
	tv.dependency 'AlipaySDK/openssl'
	tv.source_files = 'AlipaySDK/Util'
	tv.requires_arc = true
	end
  s.resources = 'AlipaySDK/AlipaySDK.bundle'
  s.vendored_frameworks = 'AlipaySDK/AlipaySDK.framework','AlipaySDK/libcrypto.a','AlipaySDK/libssl.a'
  s.libraries = 'c++'
 # s.public_header_files = 'AlipaySDK/AlipaySDK.framework/Headers/*.h'
  s.frameworks = 'CoreTelephony', 'SystemConfiguration','UIKit','Foundation','QuartzCore','CoreText','CoreGraphics','CoreMotion','CFNetwork'
 # s.dependency 'OpenSSL-Universal'

end
