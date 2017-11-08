
//
//  UIFont+Extension.swift
//  project
//
//  Created by Super on 2017/9/14.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    /**
     自定义字体 -- 粗体
     */
    class func customFont_FZLTZCHJW(fontSize size : CGFloat = 12) -> UIFont {
        return UIFont(name: "FZLanTingHeiS-DB1-GB", size: size)!
    }
    
    /**
     自定义字体 - 细体
     */
    class func customFont_FZLTXIHJW(fontSize size : CGFloat = 12) -> UIFont {
        return UIFont(name: "FZLanTingHeiS-L-GB", size: size)!
    }
    
    /**
     自定义字体 - 邪邪的那种
     */
    class func customFont_Lobster (fontSize size : CGFloat = 12) -> UIFont {
        return UIFont(name: "Lobster 1.4", size: size)!
    }
    
    class func customFont(fontPath path : String!, fontSize size : CGFloat = 13) -> UIFont {
        guard let _ = path else {
            return UIFont.systemFont(ofSize: size)
        }
        // 获取字体路径
        let url = NSURL(fileURLWithPath: path)
        let fontDataProvider : CGDataProvider = CGDataProvider(url: url)!
        let fontRef : CGFont = CGFont(fontDataProvider)!
        CTFontManagerRegisterGraphicsFont(fontRef, nil);
        let fontName : NSString = fontRef.postScriptName!
        let font = UIFont(name: fontName as String, size: size)
        return font!
    }
}
