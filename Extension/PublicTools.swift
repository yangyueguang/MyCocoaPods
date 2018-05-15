
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
    public override init() {
        let info = Bundle.main.infoDictionary
        region = info!["CFBundleDevelopmentRegion"] as! String
        name = info!["CFBundleDisplayName"] as! String
        bundle = info!["CFBundleExecutable"] as! String
        identifier = info!["CFBundleIdentifier"] as! String
        infoVersion = info!["CFBundleInfoDictionaryVersion"] as! String
        bundleName = info!["CFBundleName"] as! String
        version = info!["CFBundleShortVersionString"] as! String
        build = info!["CFBundleVersion"] as! Int32
        platVersion = info!["DTPlatformVersion"] as! String
        lessVersion = info!["MinimumOSVersion"] as! String
        launchName = info!["UILaunchStoryboardName"] as! String
        mainName = info!["UIMainStoryboardFile"] as! String
        deviceType = UIDevice.current.userInterfaceIdiom
        wechatAvalueble = UIApplication.shared.canOpenURL(URL(string: "weixin://")!)
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
    class func fileSizeAtPath(_ filePath:String)->Double{
        let manager = FileManager.default
        do {
            let attr = try manager.attributesOfItem(atPath:filePath)
            return attr[FileAttributeKey.size] as! Double
        } catch  {
            return 0
        }
    }
    class func folderSizeAtPath(_ folderPath:String)->Double{
        let manager = FileManager.default
        var folderSize = 0.0
        var isDir: ObjCBool = true
        if manager.fileExists(atPath: folderPath, isDirectory: &isDir){
            if isDir.boolValue{
                let childFilesEnumerator = manager.enumerator(atPath: folderPath)
                while let fileName = childFilesEnumerator?.nextObject(){
                    let absolutePath = "\(folderPath)\(fileName)"
                    folderSize += self.folderSizeAtPath(absolutePath)
                }
            }else{
                folderSize += fileSizeAtPath(folderPath)
            }
        }
        return folderSize
    }
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
    class func openSettings(_ block: @escaping (_: Bool) -> Void) {
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            block(false)
        } else {
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if let anUrl = url {
                if UIApplication.shared.canOpenURL(anUrl) {
                    UIApplication.shared.open(anUrl, options: [:], completionHandler: {(_ success: Bool) -> Void in
                        block(success)
                    })
                } else {
                    block(false)
                }
            }
        }
    }
    ///添加系统层面的搜索
    class func addSearchItem(title:String?,des:String?,thumURL:URL?,identifier:String?,keywords:[String]?){
        let sias = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        sias.title = title
        sias.thumbnailURL = thumURL
        sias.contentDescription = des
        sias.keywords = keywords
        let searchableItem = CSSearchableItem(uniqueIdentifier:identifier,domainIdentifier:"items",attributeSet:sias)
        addSearchItems([searchableItem])
    }
    ///添加系统层面的搜索
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
}
