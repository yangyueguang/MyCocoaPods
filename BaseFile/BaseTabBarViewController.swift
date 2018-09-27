//
//  BaseTabBarViewController.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
import UIKit
@objcMembers
open class BaseTabBarViewController: UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let barItem = UITabBarItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        tabBar.barTintColor = .green
        tabBar.tintColor = .yellow
        view.backgroundColor = .black
    }
    fileprivate func addChildViewController(_ controller: UIViewController, title:String, imageName:String){
        controller.tabBarItem.image = UIImage(named: imageName)
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        controller.tabBarItem.title = title
        controller.title = title
        let nav = BaseNavigationViewController()
        nav.addChild(controller)
        addChild(nav)
    }
}
