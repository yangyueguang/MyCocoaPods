//
//  PublicFunction.swift
import Foundation
import UIKit
func Dlog<T>(message: T,logError: Bool = false,file: String = #file,method: String = #function,line: Int = #line){
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
func Version7()->Bool{
    guard let version = Float(UIDevice.current.systemVersion) else {
        return false
    }
    return version >= 7
}
func getTopHeight()->CGFloat{
    if APPH == 812.0{
        return 88.0
    }
    return 64.0
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
