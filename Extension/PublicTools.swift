
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
@objcMembers
public class APP:NSObject{
    let region:String!
    let name:String!
    let bundle:String!
    var icon=UIImage()
    let identifier:String!
    let infoVersion:String!
    let bundleName:String!
    let version:String!
    let build:Int32
    let platVersion:String!
    let lessVersion:String!
    var allowLoad=false
    let launchName:String!
    let mainName:String!
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
    static let app = APP()
   
    
    
    
}
