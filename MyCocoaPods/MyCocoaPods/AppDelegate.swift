
import UIKit
import AVFoundation
//import Bugly
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {//WXApiDelegate
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector:#selector(test), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: UIApplication.didBecomeActiveNotification, object: nil)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        return true
    }
    
    class func backgroundPlayerID(_ backTaskId: UIBackgroundTaskIdentifier) -> UIBackgroundTaskIdentifier {
        //设置并激活音频会话类别
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try? session.setActive(true)
        //允许应用程序接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //设置后台任务ID
        var newTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        newTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            if newTaskId != UIBackgroundTaskIdentifier.invalid && backTaskId != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(backTaskId)
            }
        })
        return newTaskId
    }
    
    //当应用程序即将从活动状态移动到非活动状态时发送。对于某些类型的临时中断（例如传入的电话或SMS消息），或者当用户退出应用程序并开始向后台状态转换时，这种情况可能发生。
    func applicationWillResignActive(_ application: UIApplication) {
        //[BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
        print("\n\n倔强的打出一行字告诉你我要挂起了。。\n\n")
        let _: UIBackgroundTaskIdentifier? = AppDelegate.backgroundPlayerID(UIBackgroundTaskIdentifier.invalid)
    }
    //使用此方法释放共享资源，保存用户数据，取消计时器，并存储足够的应用程序状态信息，以恢复应用程序的当前状态，以防止其稍后被终止。
    //如果您的应用程序支持后台执行，这种方法被称为替代applicationWillTerminate:当用户退出
    func applicationDidEnterBackground(_ application: UIApplication) {
        //允许后台播放音乐
        application.beginBackgroundTask {
            application.applicationIconBadgeNumber = 0
        }
    }
    //作为从背景到活动状态的转换的一部分调用，在这里您可以撤消在进入后台时所做的许多更改。
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    //重新启动的任何任务，是paused（或没有开始应用），当这是不活动的。如果我此前的应用背景，optionally refresh的用户界面。
    func applicationDidBecomeActive(_ application: UIApplication) {
        //[BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    }
    //当应用程序即将终止时调用。如果需要保存数据。见applicationDidEnterBackground
    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    // MARK: - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        if (url.host == "safepay") {
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                  print("result = \(String(describing: resultDic))")
//            })
//            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                print("result = \(String(describing: resultDic))")
//            })
//            return true
//        }else if (url.host == "pay") {
//            return WXApi.handleOpen(url, delegate: self)
//        }else {
//            return ShareSDK.handleOpen(url, wxDelegate: self)
//        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if (url.host == "safepay") {
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                print("result = \(String(describing: resultDic))")
//            })
//            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                print("result = \(String(describing: resultDic))")
//            })
//            return true
//        }else if (url.host == "pay") {
//            return WXApi.handleOpen(url, delegate: self)
//        }else {
//            return ShareSDK.handleOpen(url, wxDelegate: self)
//        }
//        return ShareSDK.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
        return true
    }
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (url.host == "safepay") {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//                print("result = \(String(describing: resultDic))")
//            })
//        }
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic:[AnyHashable : Any]?) in
//            print("result = \(String(describing: resultDic))")
//        })
//        //微信的
//        WXApi.handleOpen(url, delegate: WXApiManager.shared())
//        ShareSDK.handleOpen(url, wxDelegate: self)
        return true
    }
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let userInfo = userActivity.userInfo {
                let selectedItem = userInfo[CSSearchableItemActivityIdentifier] as! String
                print(selectedItem)
            }
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: self.window)
        let rect = UIApplication.shared.statusBarFrame
        if rect.contains(location!) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ScrollTop"), object: nil)
        }
    }
    @objc private func test(){
        
    }
}
extension NSURLRequest{
    class func allowsAnyHTTPSCertificateForHost(_ host:String)->Bool{
        return true
    }
}
