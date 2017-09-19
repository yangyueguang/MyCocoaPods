//
//  UIColor-Extension.swift
//  crchat
//
//  Created by Ling.Cai on 2017/8/1.
//  Copyright © 2017年 Croninfo. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex:String,alpha:Float = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(alpha)
        )
    }
    
    class func RGB(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat) -> UIColor {
        return RGBA(R, G, B, 1.0)
    }
    class func RGBA(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat,_ A: CGFloat) -> UIColor {
        return UIColor(red: R/256.0, green: G/256.0, blue: B/256.0, alpha: A)
    }
    
    class func HEX(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
