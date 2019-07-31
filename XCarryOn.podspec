Pod::Spec.new do |s|
    s.name         = "XCarryOn"
    s.version      = "0.4.5"
    s.license      = "MIT"
    s.swift_version = '5.0'
    s.requires_arc = true
    s.source_files = "CarryOn"
    s.summary      = "这是基本的类的继承。"
    s.frameworks   = 'UIKit','Foundation'
    s.description  = "这是基本的类的继承和工具类"
    s.author       = { "yangyueguang" => "2829969299@qq.com" }
    s.social_media_url = 'https://www.github.com/yangyueguang'
    s.documentation_url = 'https://www.github.com/yangyueguang'
    s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
    s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
    s.ios.deployment_target = '10.0'
end
