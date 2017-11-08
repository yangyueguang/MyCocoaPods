//
//  UIAlertController+Extension.swift
//  project
//
//  Created by Super on 2017/11/8.
//  Copyright © 2017年 Super. All rights reserved.
//
import UIKit
import Foundation
extension UIAlertController {
    @objc
    class func alert(_ viewController:UIViewController,_ title:String,_ message:String,T1:String,T2:String,confirm1: @escaping () -> Void,confirm2: @escaping () -> Void){
        let con = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let a = UIAlertAction(title: T1, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            confirm1()
        })
        let b = UIAlertAction(title: T2, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            confirm2()
        })
        con.addAction(a)
        con.addAction(b)
        viewController.present(con, animated: true, completion: {() -> Void in
        })
    }

}
