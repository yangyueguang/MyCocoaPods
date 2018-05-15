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

