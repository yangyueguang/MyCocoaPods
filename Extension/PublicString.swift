//
//  PublicString.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
let basePath = "api"
let baseDomain = "https://itourtest.croninfo.com"
let basePicPath = "https://itourtest.croninfo.com/res/"
let APPStoreUpdate = "https://itunes.apple.com/us/app/id1239280240"//AppStore版本更新网页
///API
let CityLocation = "http://192.168.1.159:7100/api/v1/city/pos?lang=en"
let alertErrorTxt = "服务器异常,请稍后再试"
let topHeight = 64.0

/// 弹出登录视图
let Notif_Login = "Notif_Login"
/// 搜索标签按钮
let Notif_BtnAction_SearchTag = "Notif_BtnAction_SearchTag"

/// 全局背景
let Color_GlobalBackground = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
let Color_GlobalLine = UIColor(red: 237.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
let Color_NavBackground = UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0)

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let APPW = UIScreen.main.bounds.width
let APPH = UIScreen.main.bounds.height
struct Url {
    //申请提现：
    static let PeiYouTiXianRequest = "order/ApplyWithdrawal"
    //陪游取得收款账户和余额
    static let PeiYouAccountInfo = "Account/Companion_AccountNumber"
    //查看游客简介
    static let ScanTouriestIntroduction = "account/Get_Tourist_Info"
}

//Mark: 字符串：UserDefualt 存储字符串
struct UserDefaultForUser {
    static let AccessToken = "AccessToken"
    static let UserId = "TokenUserId"
    static let AccessTokenDate = "AccessTokenDate"
    static let UserModel = "UserModel"
    static let CouponNo = "CouponNo"
    static let LastBuilding = "LastBuildingModel"
    static let SelectCityId = "SelectCityId"
    static let StatusCode = "StatusCode"
    
}

enum ContentType:String {
    case Video = "video"
    case Gif = "gif"
    case Image = "image"
    case Text = "text"
    case Html = "html"
}

