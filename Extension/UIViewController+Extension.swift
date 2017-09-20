
//
//  UIViewController+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation

// MARK: - UIViewController
extension UIViewController{
    
    
    func AppRootViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    //显示NavBar
    func showNavBar() -> Void {
        
        self.navigationController?.navigationBar.shadowImage = UIImage.createImageWithColor(UIColor.clear)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "LastMinute_TitleBar_621")
            , for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false;
        
    }
    
    //隐藏NavBar
    func hiddenNavBar() -> Void {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        
    }
}

