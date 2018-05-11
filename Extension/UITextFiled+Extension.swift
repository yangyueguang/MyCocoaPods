
//
//  UITextFiled+Extension.swift
import Foundation
import UIKit
public extension UITextField {
    func placeholderColor(_ color : UIColor) -> Void {
        self.setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
}
