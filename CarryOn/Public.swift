//
//  Public.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/3.
//  Copyright © 2018 Super. All rights reserved.
//

import Foundation
//
//  PublicString
import Foundation
import UIKit
public let basePath = "api"
public let baseDomain = "https://itourtest.croninfo.com"
public let basePicPath = "https://itourtest.croninfo.com/res/"
public let APPStoreUpdate = "https://itunes.apple.com/us/app/id1239280240"//AppStore版本更新网页
///API
public let CityLocation = "http://192.168.1.159:7100/api/v1/city/pos?lang=en"
public let alertErrorTxt = "服务器异常,请稍后再试"
/// 弹出登录视图
public let Notif_Login = "Notif_Login"
/// 搜索标签按钮
public let Notif_BtnAction_SearchTag = "Notif_BtnAction_SearchTag"
/// 全局背景
public let Color_GlobalBackground = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
public let Color_GlobalLine = UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
public let Color_NavBackground = UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0)
public let APPW = UIScreen.main.bounds.width
public let APPH = UIScreen.main.bounds.height
public let TopHeight:CGFloat = getTopHeight()
public let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
public let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
public let cachesPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
public let tempPath = NSTemporaryDirectory()
public let homePath = NSHomeDirectory()
public struct Url {
    public static let PeiYouTiXianRequest = "order/ApplyWithdrawal"
    public static let PeiYouAccountInfo = "Account/Companion_AccountNumber"
    public static let ScanTouriestIntroduction = "account/Get_Tourist_Info"
}
//Mark: 字符串：UserDefualt 存储字符串
public struct UserDefaultForUser {
    public static let AccessToken = "AccessToken"
    public static let UserId = "TokenUserId"
    public static let AccessTokenDate = "AccessTokenDate"
    public static let UserModel = "UserModel"
    public static let CouponNo = "CouponNo"
    public static let LastBuilding = "LastBuildingModel"
    public static let SelectCityId = "SelectCityId"
    public static let StatusCode = "StatusCode"
}
public enum ContentType:String {
    case Video = "video"
    case Gif = "gif"
    case Image = "image"
    case Text = "text"
    case Html = "html"
}

//
//  PublicFunction.swift
import Foundation
import UIKit

public func Dlog<T>(_ message: T, file: String = #file,method: String = #function,line: Int = #line){
    #if DEBUG
    print("\n\((file as NSString).lastPathComponent)[\(line)]: \(method)\n\(message)")
    #endif
}
public func Version7()->Bool{
    guard let version = Float(UIDevice.current.systemVersion) else {
        return false
    }
    return version >= 7
}
public func getTopHeight()->CGFloat{
    if APPH == 812.0{
        return 88.0
    }
    return 64.0
}
public func RGBAColor(_ R:CGFloat,_ G:CGFloat,_ B:CGFloat,_ A:CGFloat = 1.0)->UIColor{
    return UIColor(red: R, green: G, blue: B, alpha: A)
}
public func W(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.width
    }else{
        return 0
    }
}
public func H(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.size.height
    }else{
        return 0
    }
}
public func X(_ obj:UIView?)->CGFloat{
    if obj != nil {
        return obj!.frame.origin.x
    }else{
        return 0
    }
}
public func Y(_ obj:UIView)->CGFloat{
    return obj.frame.origin.y
}
public func XW(_ obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.x + obj!.frame.size.width
    }else{
        return 0
    }
}
public func YH(_ obj:UIView?)->CGFloat{
    if obj != nil{
        return obj!.frame.origin.y + obj!.frame.size.height
    }else{
        return 0
    }
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
