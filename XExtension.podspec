Pod::Spec.new do |s|
    s.name         = "XExtension"
    s.version      = "0.4.3"
    s.license      = "MIT"
    s.swift_version = '4.2'
    s.requires_arc = true
    s.source_files  = "Extension"
    s.summary      = "这是Swift的类的拓展集合."
    s.frameworks   = 'UIKit','Foundation'
    s.description  = "这是Swift的类的拓展集合，这个字段一般比summary长"
    s.author       = { "yangyueguang" => "2829969299@qq.com" }
    s.social_media_url = 'https://www.github.com/yangyueguang'
    s.documentation_url = 'https://www.github.com/yangyueguang'
    s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
    s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }

    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '10.10'
    s.tvos.deployment_target = '10.0'
    s.watchos.deployment_target = '3.0'

  # s.subspec 'w' do |cv|
  # cv.source_files = 'BaseFile/BaseCollectionView'
  # cv.requires_arc = true
  # end
  # s.dependcy = ""
end
