Pod::Spec.new do |s|
  s.name         = "XMirror"
  s.version      = "0.3.7"
  s.summary      = "这是Swift的类的拓展集合."
  s.frameworks   = 'UIKit','Foundation'
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.description  = "这是Swift的类的拓展集合"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author       = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
  s.source_files  = "XMirror"
  end
