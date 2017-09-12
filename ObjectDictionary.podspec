Pod::Spec.new do |s|
  s.name         = "ObjectDictionary"
  s.version      = "0.1.1"
  s.summary      = "这是字典转模型和模型转字典的工具类"
  s.frameworks = 'UIKit','Foundation'
#,'objc'
  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是字典转模型和模型转字典的工具类"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "ObjectDictionary"
#	s.subspec 'JSONKit' do |js|
#       js.source_files = 'GRBNavigationKit/JSONKit'
#	js.requires_arc = false
#	end
end
