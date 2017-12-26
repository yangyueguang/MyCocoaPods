Pod::Spec.new do |s|
  s.name         = "XASIHttpRequest"
  s.version      = "0.3.1"
  s.summary      = "这是ASI网络请求框架."
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是微信分享与支付集合。"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "XASIHttpRequest"
  #s.dependency ''
  s.requires_arc = false
  	s.subspec 'ASIWeb' do |aw|	 
        aw.source_files = 'XASIHttpRequest/ASIWebPageRequest'
 	aw.requires_arc = false
       	end
	s.subspec 'ASICloud' do |ac|
	ac.source_files = 'XASIHttpRequest/CloudFiles'
	ac.requires_arc = false
	end

  	s.subspec 'AS3' do |as|  
        as.source_files = 'XASIHttpRequest/S3'
        as.requires_arc = false
        end
        s.subspec 'AReachability' do |ar|
        ar.source_files = 'XASIHttpRequest/Reachability'
        ar.requires_arc = false
        end

end
