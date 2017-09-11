Pod::Spec.new do |s|
  s.name         = "Category"
  s.version      = "0.0.9"
  s.summary      = "Yes ,this is my Summary is A short description of KNavigate."
  s.frameworks = 'UIKit','Foundation','sys','CommonCrypto','StoreKit','net','AudioToolbox'
 # s.requires_arc = true
 # s.platform = :ios
 # s.ios.deployment_target = '8.0'
 # s.description  = "this is the description you know ? yes ,so ,what do you want to do?Yes you are right"
  s.homepage     = "https://github.com/yangyueguang/MyCocoaPods"
  s.license      = "MIT"
  s.author             = { "yangyueguang" => "2829969299@qq.com" }
  s.source       = { :git => "https://github.com/yangyueguang/MyCocoaPods.git", :tag => "#{s.version}" }
 # s.source_files  = 'Category/Utility.{h,m}'
 # "GestureNavi/*.{h,m}"
  s.dependency 'MyPageControl'
  s.dependency 'NSData+expanded'
  s.dependency 'NSDate+expanded'
  s.dependency 'NSDictionary+expanded'
  s.dependency 'NSMutableArray+expanded'
  s.dependency 'NSObject+expanded'
  s.dependency 'NSString+expanded'
  s.dependency 'SDDataCache'
  s.dependency 'UIColor+expanded'
  s.dependency 'UIControl+expanded'
  s.dependency 'UIImage+expanded'
  s.dependency 'UILabel+expanded'
  s.dependency 'UIView+expanded'
  #s.dependency 'Utility'

end
