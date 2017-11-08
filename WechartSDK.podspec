Pod::Spec.new do |s|
  s.name         = "WechartSDK"
  s.version      = "0.2.8"
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
  s.source_files  = "WechartSDK"
  s.dependency 'WechatOpenSDK'
  s.resources = 'WechartSDK/resource/*.*'
  	 s.subspec 'Control' do |cv|	 
       	 cv.source_files = 'WechartSDK/Control'
  	 cv.requires_arc = true
       	end
	s.subspec 'ViewController' do |tv|
 	tv.dependency 'WechartSDK/Control'
	tv.source_files = 'WechartSDK/ViewController'
	tv.requires_arc = true
	end

end
