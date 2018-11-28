
//
//  UITextFiled+Extension.swift
import Foundation
import UIKit
public extension UITextField {
    func placeholderColor(_ color : UIColor) -> Void {
        self.setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
    class func textFieldl(withFrame aframe: CGRect, font afont: UIFont?, color acolor: UIColor?, placeholder aplaceholder: String?, text atext: String?) -> UITextField? {
        let baseTextField = UITextField(frame: aframe)
        baseTextField.keyboardType = .default
        baseTextField.borderStyle = .none
        baseTextField.clearButtonMode = .whileEditing
        baseTextField.textColor = acolor
        baseTextField.placeholder = aplaceholder
        baseTextField.font = afont
        baseTextField.isSecureTextEntry = false
        baseTextField.returnKeyType = .done
        baseTextField.text = atext
        baseTextField.contentVerticalAlignment = .center
        return baseTextField
    }

}
