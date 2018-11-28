
//
//  UILabel+Extension.swift
import Foundation
import UIKit
public extension UILabel {
    //下划线
    func bottomLine(_ str : String) -> Void {
        let str1 = NSMutableAttributedString(string: str)
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value: NSUnderlineStyle.single.rawValue as Int)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
        str1.addAttribute(NSAttributedString.Key.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range1)
        self.attributedText = str1
    }
    @objc func txtCopy(_ item: Any) {
        UIPasteboard.general.string = text
    }
    public convenience init(frame: CGRect, text: String, font: UIFont, color: UIColor = .black, alignment: NSTextAlignment = .left, lines: Int = 0, lineSpace: CGFloat?, shadowColor: UIColor = UIColor.clear) {
        self.init(frame: frame)
        self.font = font
        self.text = text
        self.backgroundColor = UIColor.clear
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = lines
        self.shadowColor = shadowColor
        if let lineSpace = lineSpace {
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = lineSpace
            let attributedString = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle:paragraphStye])
            self.attributedText = attributedString
        }
    }

    func labelLongPress(_ longPress: UILongPressGestureRecognizer) {
        self.becomeFirstResponder()
        let popMenu = UIMenuController.shared
        let item = UIMenuItem(title: "复制", action: #selector(txtCopy(_:)))
        popMenu.menuItems = [item]
        popMenu.arrowDirection = .down
        popMenu.setTargetRect(self.bounds, in: self)
        popMenu.setMenuVisible(true, animated: true)
    }
}

