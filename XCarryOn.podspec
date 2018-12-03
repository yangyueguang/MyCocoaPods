Pod::Spec.new do |s|
  s.name         = "XCarryOn"
  s.version      = "0.3.8"
  s.summary      = "这是基本的类的继承。"
  s.frameworks   = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.description  = "这是基本的类的继承和工具类"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author       = { "yangyueguang" => "2829969299@qq.com" }
  s.source         = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files   = "CarryOn"
end
