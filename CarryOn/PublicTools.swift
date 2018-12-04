
//
//  PublicTools.swift
//  project
//
//  Created by Super on 2017/9/8.
//  Copyright © 2017年 Super. All rights reserved.
//
import QuartzCore
import StoreKit
import AudioToolbox
import Foundation
import LocalAuthentication
import CoreSpotlight
import MobileCoreServices
@objcMembers
public class APP:NSObject{
    public let region:String!
    public let name:String!
    public let bundle:String!
    public var icon=UIImage()
    public let identifier:String!
    public let infoVersion:String!
    public let bundleName:String!
    public let version:String!
    public let build:Int32
    public let platVersion:String!
    public let lessVersion:String!
    public var allowLoad=false
    public let launchName:String!
    public let mainName:String!
    public let deviceType:UIUserInterfaceIdiom!
    public let wechatAvalueble:Bool!
    public let systemVersion: Float!
    public override init() {
        let info = Bundle.main.infoDictionary
        region = info!["CFBundleDevelopmentRegion"] as? String
        name = info!["CFBundleDisplayName"] as? String
        bundle = info!["CFBundleExecutable"] as? String
        identifier = info!["CFBundleIdentifier"] as? String
        infoVersion = info!["CFBundleInfoDictionaryVersion"] as? String
        bundleName = info!["CFBundleName"] as? String
        version = info!["CFBundleShortVersionString"] as? String
        build = info!["CFBundleVersion"] as! Int32
        platVersion = info!["DTPlatformVersion"] as? String
        lessVersion = info!["MinimumOSVersion"] as? String
        launchName = info!["UILaunchStoryboardName"] as? String
        mainName = info!["UIMainStoryboardFile"] as? String
        deviceType = UIDevice.current.userInterfaceIdiom
        wechatAvalueble = UIApplication.shared.canOpenURL(URL(string: "weixin://")!)
        systemVersion = Float(UIDevice.current.systemVersion) ?? 8.0
        super.init()
        if let transport:[String:Any] = info!["NSAppTransportSecurity"] as? [String : Any]{
            self.allowLoad = transport["NSAllowsArbitraryLoads"] as! Bool
        }
        if let iconDict:[String:Any] = info!["CFBundleIcons"] as? [String : Any]{
            if let iconfiles:[String:Any] = iconDict["CFBundlePrimaryIcon"] as? [String : Any]{
                self.icon = UIImage(named:iconfiles["CFBundleIconName"] as! String)!
            }
        }
    }
}
@objcMembers
public class PublicTools:NSObject{
    public let app = APP()
    /// 弹出指纹验证的视图
    class func showTouchID(desc:String="",_ block: @escaping (_ error:LAError?,_ m:String?) -> Void){
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            block(LAError(_nsError:NSError()),"系统版本不支持TouchID")
            return
        }
        let context = LAContext()
        context.localizedFallbackTitle = desc
        var error:NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            block(LAError(_nsError: error!),"当前设备不支持TouchID")
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: desc, reply: {(_ success: Bool, _ error: Error?) -> Void in
            var m = "验证通过"
            if success{
                block(nil,m)
            }else if let error=error{
                let laerror = LAError.init(_nsError: error as NSError)
                switch laerror.code{
                case LAError.authenticationFailed:m="验证失败";break;
                case LAError.userCancel:m="被用户手动取消";break;
                case LAError.userFallback:m="选择手动输入密码";break;
                case LAError.systemCancel:m="被系统取消";break;
                case LAError.passcodeNotSet:m="没有设置密码";break;
                case LAError.touchIDNotAvailable:m="TouchID无效";break;
                case LAError.touchIDNotEnrolled:m="没有设置TouchID";break;
                case LAError.touchIDLockout:m="多次验证TouchID失败";break;
                case LAError.appCancel:m="当前软件被挂起并取消了授权 (如App进入了后台等)";break;
                case LAError.invalidContext:m="当前软件被挂起并取消了授权";break;
                case LAError.notInteractive:m="当前设备不支持TouchID";break;
                default:m="当前设备不支持TouchID";break;
                }
                block(laerror,m)
            }
        });
    }

    /// 软件自更新
    class func updateAPPWithPlistURL(_ url:String="http://dn-mypure.qbox.me/iOS_test.plist",block: @escaping(Bool)->Void){
        let serviceURL = "itms-services:///?action=download-manifest&url="
        let realUrl = URL(string:"\(serviceURL)\(url)")
        UIApplication.shared.open(realUrl!, options: [:]) { (success) in
            block(success)
            if success{
                exit(0)
            }
        }
    }
    /// 打开系统的设置
    static func openSettings(_ closure: @escaping (Bool) -> Void) {
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            closure(false)
        } else {
            let url = URL(string: UIApplication.openSettingsURLString)
            if let anUrl = url {
                if UIApplication.shared.canOpenURL(anUrl) {
                    UIApplication.shared.open(anUrl, options: [:], completionHandler: { success in
                        closure(success)
                    })
                } else {
                    closure(false)
                }
            }
        }
    }
    /// 添加系统层面的搜索
    class func addSearchItem(title:String?,des:String?,thumURL:URL?,identifier:String?,keywords:[String]?){
        let sias = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        sias.title = title
        sias.thumbnailURL = thumURL
        sias.contentDescription = des
        sias.keywords = keywords
        let searchableItem = CSSearchableItem(uniqueIdentifier:identifier,domainIdentifier:"items",attributeSet:sias)
        addSearchItems([searchableItem])
    }
    ///批量添加系统层面的搜索
    class func addSearchItems(_ searchItems:[CSSearchableItem]){
        let searchIndex = CSSearchableIndex.default()
        searchIndex.indexSearchableItems(searchItems){error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    ///删除系统层面的搜索
    class func deleteSearchItem(identifiers:[String],closure:((Error?) -> Swift.Void)? = nil){
        let searchIndex = CSSearchableIndex.default()
        searchIndex.deleteSearchableItems(withIdentifiers: identifiers, completionHandler: closure)
    }

    //播放提示音
    func playSystemSound() {
        //        var sound: SystemSoundID //系统声音的id 取值范围为：1000-2000
        /*ReceivedMessage.caf--收到信息，仅在短信界面打开时播放。
         sms-received1.caf-------三全音sms-received2.caf-------管钟琴sms-received3.caf-------玻璃sms-received4.caf-------圆号
         sms-received5.caf-------铃声sms-received6.caf-------电子乐SentMessage.caf--------发送信息
         */
        //        let path = "/System/Library/Audio/UISounds/\("sms-received1").\("caf")"
        //        Bundle(identifier: "com.apple.UIKit")?.path(forResource: soundName, ofType: soundType) //得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //        Bundle.main.url(forResource: "tap", withExtension: "aif") //获取自定义的声音
        //        let url: CFURL = URL(fileURLWithPath: path) as CFURL
        //        let error: OSStatus = AudioServicesCreateSystemSoundID(url, &sound)
        //        if error != kAudioServicesNoError {
        //            print("获取的声音的时候，出现错误")
        //        }
        //        AudioServicesPlaySystemSound(sound)
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    /// 在主线程运行
    func performSelectorOnMainThread(selector aSelector: Selector,withObject object:AnyObject! ,waitUntilDone wait:Bool = false){
        if self.responds(to: aSelector){
            var continuego = false
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.fsh.dispatch", attributes: [])
            queue.async(group: group,execute: {
                queue.async(execute: {
                    Thread.detachNewThreadSelector(aSelector, toTarget:self, with: object)
                    continuego = true
                })
            })
            if wait{
                let ret = RunLoop.current.run(mode: RunLoop.Mode.default, before: Foundation.Date.distantFuture )
                while (!continuego && ret){
                }
            }
        }
    }
    /// json转Data
    class func jsonToData(_ jsonResponse: AnyObject) -> Data? {
        do{
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data;
        }catch{
            return nil
        }
    }
    /// data转json
    class func dataToJson(_ data: Data) -> AnyObject? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as AnyObject?
        }catch{
            return nil
        }
    }
  
    /// 变成没有null的字符串
    func notEmpty(_ item:Any)->String{
        if item is NSNull{
            return "-"
        }else if item is String{
            var ss = String(describing:item)
            if ss == ""{
                ss = "-"
            }
            return ss
        }else if item is NSNumber{
            return String(describing:item)
        }else{
            return "-"
        }
    }
    /// 变成decimalNumber
    func decimalNumber(_ s:Any)->NSDecimalNumber{
        if s is String{
            let ss:NSString = s as! NSString
            let doubleValue = (ss.replacingOccurrences(of:",", with: "") as NSString).doubleValue
            return NSDecimalNumber(value: doubleValue)
        }else if s is NSNumber{
            return NSDecimalNumber(value: (s as! NSNumber).doubleValue)
        }else{
            return NSDecimalNumber(value:0.0)
        }
    }

}
extension PublicTools: SKStoreProductViewControllerDelegate {
    /// 根据appid打开AppStore
    func openAppStore(_ appId: String) {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(appId)"
        let url = URL(string: urlStr)
        if let anUrl = url {
            UIApplication.shared.open(anUrl, options: [:]) { (isSuccess) in
            }
        }
        let storeProductVC = SKStoreProductViewController()
        storeProductVC.delegate = self
        let dict = [SKStoreProductParameterITunesItemIdentifier : appId]
        storeProductVC.loadProduct(withParameters: dict, completionBlock: { result, error in
            if result {
                UIApplication.shared.keyWindow?.rootViewController?.present(storeProductVC, animated: true)
            }
        })
    }
    private func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {}
    }
}
