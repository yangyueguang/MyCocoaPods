Pod::Spec.new do |s|
  s.name         = "XWechartSDK"
  s.version      = "0.3.1"
  s.summary      = "这是微信分享与支付集合."
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是微信分享与支付集合。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "XWechartSDK"
  s.dependency 'WechatOpenSDK'
  s.resources = 'XWechartSDK/resource/*.*'
  	 s.subspec 'Control' do |cv|	 
       	 cv.source_files = 'XWechartSDK/Control'
  	 cv.requires_arc = true
       	end
	s.subspec 'ViewController' do |tv|
 	tv.dependency 'XWechartSDK/Control'
	tv.source_files = 'XWechartSDK/ViewController'
	tv.requires_arc = true
	end

end
