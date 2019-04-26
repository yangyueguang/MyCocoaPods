Pod::Spec.new do |s|
    s.name         = "MacExtension"
    s.version      = "0.4.3"
    s.license      = "MIT"
    s.swift_version = '4.2'
    s.requires_arc = true
    s.source_files  = "MacExtension"
    s.summary      = "这是Swift的类的Mac版本拓展集合."
    s.frameworks   = 'Cocoa','Foundation'
    s.description  = "这是Swift的类的拓展集合,这个字段一般比summary长"
    s.author       = { "yangyueguang" => "2829969299@qq.com" }
    s.social_media_url = 'https://www.github.com/yangyueguang'
    s.documentation_url = 'https://www.github.com/yangyueguang'
    s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
    s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
    s.osx.deployment_target = '10.10'
end
