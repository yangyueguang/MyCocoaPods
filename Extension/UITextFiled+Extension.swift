
//
//  UITextFiled+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
// MARK: - UITextField
extension UITextField {
    
    //设置placeholder颜色
    func placeholderColor(_ color : UIColor) -> Void {
        
        self.setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
}
