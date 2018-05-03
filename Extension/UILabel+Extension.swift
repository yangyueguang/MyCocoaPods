
//
//  UILabel+Extension.swift
import Foundation
import UIKit
extension UILabel {
    //下划线
    func bottomLine(_ str : String) -> Void {
        let str1 = NSMutableAttributedString(string: str)
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
        str1.addAttribute(NSAttributedStringKey.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range1)
        self.attributedText = str1
    }
    func txtCopy(_ item: Any) {
        UIPasteboard.general.string = text
        print("________copy:\(String(describing: text))")
    }
}

