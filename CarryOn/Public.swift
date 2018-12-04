//
//  Public.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/3.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Foundation
public let APPW = UIScreen.main.bounds.width
public let APPH = UIScreen.main.bounds.height
public var TopHeight:CGFloat {
    if APPH >= 812.0{
        return 88.0
    }
    return 64.0
}
/// 系统路径
public struct XPath {
    public let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    public let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let caches = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let temp = NSTemporaryDirectory()
    public let home = NSHomeDirectory()
}
/// 文件类型
public enum FileType:String {
    case video = "video"
    case gif = "gif"
    case image = "image"
    case text = "text"
    case html = "html"
}
/// Debug打印
public func Dlog<T>(_ message: T, file: String = #file,method: String = #function,line: Int = #line){
    #if DEBUG
    print("\n\((file as NSString).lastPathComponent)[\(line)]: \(method)\n\(message)")
    #endif
}

/// 打印字典转换的模型
public func jsonToModelPrint(_ dict:[String:Any], name:String, space: String = ""){
    let getType = {(value:Any) -> String? in
        var s: String?
        switch value{
        case is Bool:s = "Bool"
        case is String:s = "String"
        case is Int:s = "Int"
        case is NSNumber:s = "Double"
        case is NSNull:s = "NSNull"
        default:break
        }
        return s
    }
    let firstUppercase = {(name: String) -> String in
        return name.prefix(1).uppercased() + name.suffix(from: name.index(name.startIndex, offsetBy: 1))
    }

    func printArray(_ value:Any, key: String, space: String) {
        if value is NSDictionary{
            jsonToModelPrint(value as! [String:Any],name:firstUppercase(key), space: space)
        }else if value is NSArray{
            printArray((value as! [Any]).first ?? "", key: firstUppercase(key), space: space)
        }else{
        }
    }
    print("\n\(space)@objcMembers\n\(space)class \(firstUppercase(name)): NSObject {")
    let newspace = space.compactMap({ return "\($0)" }).reduce("\t") { $0 + $1 }
    for (key,value) in dict{
        if value is NSDictionary{
            print("\(newspace)var \(key): \(getType(value) ?? firstUppercase(key))?")
            jsonToModelPrint(value as! [String:Any],name:key, space: newspace + "\t")
        }else if value is NSArray{
            let value = (value as! NSArray).firstObject ?? ""
            print("\(newspace)var \(key): [\(getType(value) ?? firstUppercase(key))] = []")
            printArray(value, key: key, space: newspace + "\t")
        }else{
            print("\(newspace)var \(key): \(getType(value) ?? firstUppercase(key))\(value is NSNumber ? " = 0" : "?")")
        }
    }
    print("\(space)}")
}
