
//
//  UITextFiled+Extension.swift
import Foundation
import UIKit
extension UITextField {
    func placeholderColor(_ color : UIColor) -> Void {
        self.setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
}
