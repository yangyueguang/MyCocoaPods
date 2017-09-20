
//
//  UINavigationController+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
import UIKit
// MARK: - 自定义POP事件
extension UINavigationController  {
    
    class func zjPopViewControllerAnimated(_ nav : UINavigationController) {
        
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationDuration(0.75)
        UIView.setAnimationTransition(UIViewAnimationTransition.none, for: nav.view, cache: false)
        UIView.commitAnimations()
        
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.375)
        nav.popViewController(animated: false)
        UIView.commitAnimations()
        nav.popViewController(animated: true)
        
    }
}
