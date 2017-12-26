Pod::Spec.new do |s|
  s.name         = "BaseFile"
  s.version      = "0.3.1"
  s.summary      = "这是所有的基本类集合."
  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是所有的基本类的集合。"
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
  s.source_files  = "BaseFile"
  	 s.subspec 'BaseCollectionView' do |cv|
   	 cv.source_files = 'BaseFile/BaseCollectionView'
  	 cv.requires_arc = true
       	end
	s.subspec 'BaseTableView' do |tv|
	tv.source_files = 'BaseFile/BaseTableView'
	tv.requires_arc = true
	end
   s.dependency 'MJRefresh','~>3.1.0'
   s.dependency 'AFNetworking','~>3.0'
   s.dependency 'SDWebImage'
   s.dependency 'SVProgressHUD','~>0.9'
end
