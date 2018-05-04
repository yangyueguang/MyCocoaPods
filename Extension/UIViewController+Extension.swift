
//
//  UIViewController+Extension.swift
import Foundation
import UIKit
extension UIViewController{
    var backGestureEnable:Bool?{
        get{
            return self.backGestureEnable!
        }
        set{
            self.backGestureEnable = newValue
 self.navigationController?.interactivePopGestureRecognizer?.isEnabled = newValue!
        }
    }
    var naviLineHidden:Bool?{
        get{
            return self.naviLineHidden
        }
        set{
            self.naviLineHidden = newValue
            if newValue!{
                if self.navigationController?.navigationBar.responds(to: #selector(UINavigationBar.setBackgroundImage(_:for:))) ?? false {
                    let list = self.navigationController?.navigationBar.subviews
                    for obj: Any? in list ?? [Any?]() {
                        if (obj is UIImageView) {
                            let imageView = obj as? UIImageView
                            let list2 = imageView?.subviews
                            for obj2: Any? in list2 ?? [Any?]() {
                                if (obj2 is UIImageView) {
                                    let imageView2 = obj2 as? UIImageView
                                    imageView2?.isHidden = true
                                }
                            }
                        }
                    }
                }
            }else{
                if self.navigationController?.navigationBar.responds(to: #selector(UINavigationBar.setBackgroundImage(_:for:))) ?? false {
                    let list = self.navigationController?.navigationBar.subviews
                    for obj: Any? in list ?? [Any?]() {
                        if (obj is UIImageView) {
                            let imageView = obj as? UIImageView
                            let list2 = imageView?.subviews
                            for obj2: Any? in list2 ?? [Any?]() {
                                if (obj2 is UIImageView) {
                                    let imageView2 = obj2 as? UIImageView
                                    imageView2?.isHidden = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    var navBarClear:Bool?{
        get{
            return self.navBarClear
        }
        set{
            if navBarClear!{
self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true;
            }else{
                self.navigationController?.navigationBar.shadowImage = UIImage.createImageWithColor(UIColor.clear)
                self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "LastMinute_TitleBar_621")
                    , for: UIBarMetrics.default)
                self.navigationController?.navigationBar.isTranslucent = false;
            }
        }
    }
    func AppRootViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
}

