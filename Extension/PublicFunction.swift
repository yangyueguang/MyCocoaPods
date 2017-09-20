//
//  PublicFunction.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
func Dlog<T>(message: T,logError: Bool = false,file: String = #file,method: String = #function,line: Int = #line){
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
func appBundleVersion()->String{
    return Bundle.main.infoDictionary!["bundle version"] as! String
}
func Version7()->Bool{
    guard let version = Float(UIDevice.current.systemVersion) else {
        return false
    }
    return version >= 7
}

func documentLocalPath()->String{
    return NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)[0]
}
func RGBAColor(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat)->UIColor{
    return UIColor(red: R, green: G, blue: B, alpha: A)
}
func W(obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.width
    }else{
        return 0
    }
}
func H(obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.height
    }else{
        return 0
    }
}
func X(obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.origin.x
    }else{
        return 0
    }
}
func Y(obj:UIView)->CGFloat{
    return obj.frame.origin.y
}
func XW(obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.x + obj!.frame.size.width
    }else{
        return 0
    }
}
func YH(obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.y + obj!.frame.size.height
    }else{
        return 0
    }
}

//func LocalStr(key:String,comment:String)->id{
//    [[HXLanguageManager shareInstance] localizedStringForKey:key value:comment]
//}






