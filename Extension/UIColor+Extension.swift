
//
//  UIColor+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
// MARK: - UIColor
extension UIColor {
    
    class func HEX(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    class func RGB(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat) -> UIColor {
        return RGBA(R, G, B, 1.0)
    }
    class func RGBA(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat,_ A: CGFloat) -> UIColor {
        return UIColor(red: R/256.0, green: G/256.0, blue: B/256.0, alpha: A)
    }
    /**
     16进制取颜色，并且设置透明度
     
     - parameter hexValue:   16进制颜色值
     - parameter alphaValue: 颜色透明度
     
     - returns: 颜色
     */
    static func colorWithHex(hexValue:Int, alphaValue:CGFloat) -> UIColor
    {
        if hexValue > 0xFFF
        {
            return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(hexValue & 0xFF)  / 255.0, alpha: alphaValue)
        }else
        {
            return UIColor(red: CGFloat((hexValue & 0xF00) >> 8) / 255.0, green: CGFloat((hexValue & 0xF0) >> 4) / 255.0, blue: CGFloat(hexValue & 0xF)  / 255.0, alpha: alphaValue)
        }
    }
    
    
    
    
    /**
     16进制取颜色
     
     - parameter hexValue: 16进制颜色
     
     - returns: 颜色
     */
    static func  colorWithHex(hexValue:Int) ->UIColor
    {
        return UIColor.colorWithHex(hexValue: hexValue, alphaValue: 1)
    }
    
    
    
    
    /**
     随机颜色值
     
     - returns: 颜色
     */
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
 
    
    
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
    


    /**
     根据UIColor取想要的颜色值
     
     - parameter color: 颜色
     
     - returns: 颜色值
     */
    static func hexFromUIColor(color:UIColor) -> String
    {
        
        //还没有实现
        var myColor = color
        if (color.cgColor.numberOfComponents < 4) {
            let components = color.cgColor.components;
            myColor = UIColor(red: (components?[0])!, green: (components?[0])!, blue: (components?[0])!, alpha: (components?[1])!)
        }
        if (myColor.cgColor.colorSpace!.model != CGColorSpaceModel.rgb)
            
        {
            return "#FFFFFF"
        }
        return "FFFFFF"
    }


}
