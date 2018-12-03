//
//  OtherExtensions.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/3.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Foundation
public extension Array{
    mutating func moveObject(from: Int, to: Int) {
        if to != from {
            let obj = self[from]
            remove(at: from)
            if to >= count {
                append(obj)
            }else{
                insert(obj, at: to)
            }
        }
    }
    /// 安全的取值
    public func item(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}

public extension UIColor {
    class func HEX(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func RGB(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat) -> UIColor {
        return RGBA(R, G, B, 1.0)
    }
    class func RGBA(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat,_ A: CGFloat) -> UIColor {
        return UIColor(red: R/256.0, green: G/256.0, blue: B/256.0, alpha: A)
    }
    class func colorWithHex(hexValue:Int, alphaValue:CGFloat) -> UIColor{
        if hexValue > 0xFFF{
            return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(hexValue & 0xFF)  / 255.0, alpha: alphaValue)
        }else{
            return UIColor(red: CGFloat((hexValue & 0xF00) >> 8) / 255.0, green: CGFloat((hexValue & 0xF0) >> 4) / 255.0, blue: CGFloat(hexValue & 0xF)  / 255.0, alpha: alphaValue)
        }
    }
    class func  colorWithHex(hexValue:Int) ->UIColor{
        return UIColor.colorWithHex(hexValue: hexValue, alphaValue: 1)
    }
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    convenience init(hex:String,alpha:Float = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(alpha)
        )
    }
    class func hexFromUIColor(color:UIColor) -> String{
        //还没有实现
        var myColor = color
        if (color.cgColor.numberOfComponents < 4) {
            let components = color.cgColor.components;
            myColor = UIColor(red: (components?[0])!, green: (components?[0])!, blue: (components?[0])!, alpha: (components?[1])!)
        }
        if (myColor.cgColor.colorSpace!.model != CGColorSpaceModel.rgb){
            return "#FFFFFF"
        }
        return "FFFFFF"
    }
}

public extension UIFont {

}
public extension UIImageView {

}
public extension UISearchBar {
    convenience init(delegate: UISearchBarDelegate, backgroundColor: UIColor, backgroundImage: UIImage, holder: String) {
        self.init()
        self.delegate = delegate
        placeholder = holder
        tintColor = UIColor.white
        barStyle = UIBarStyle.blackTranslucent
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        self.backgroundImage = backgroundImage
        for subView in subviews {
            for subView1 in subView.subviews {
                if subView1.isKind(of: UITextField.self) {
                    subView1.backgroundColor = backgroundColor
                }
            }

        }
    }
}
extension FileManager {


    class func url(for dictionary: FileManager.SearchPathDirectory) -> URL?{
        return self.default.urls(for: dictionary, in: .userDomainMask).last
    }

    class func path(for directory: FileManager.SearchPathDirectory) -> String?{
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first
    }

}
public extension UIButton {
    convenience init(frame: CGRect, title: String?, font: UIFont, img: UIImage?, backGroundColor: UIColor = UIColor.clear, radios: CGFloat?, target: AnyObject?, action: Selector){
        self.init()
        self.frame = frame
        setTitle(title, for: .normal)
        titleLabel?.font = font
        setImage(img, for: .normal)
        sizeToFit()
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        if let radios = radios {
            layer.masksToBounds = true
            layer.cornerRadius = radios
        }
        addTarget(target, action: action, for: .touchUpInside)
    }

}
public extension UIAlertController {
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
public extension UIScrollView {

}
public extension UINavigationController  {
    class func zjPopViewControllerAnimated(_ nav : UINavigationController) {
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
        UIView.setAnimationDuration(0.75)
        UIView.setAnimationTransition(UIView.AnimationTransition.none, for: nav.view, cache: false)
        UIView.commitAnimations()
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.375)
        nav.popViewController(animated: false)
        UIView.commitAnimations()
        nav.popViewController(animated: true)
    }
}
public extension UIBarButtonItem {
    /// 用Button生成的自定义View
    convenience init(size: CGSize = CGSize(width: 44, height: 44), title: String?, img:UIImage?, HImg: UIImage?, target: AnyObject?, action: Selector?){
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btn.setTitle(title, for: .normal)
        btn.setImage(img, for: .normal)
        btn.setImage(HImg, for: .highlighted)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        if let action = action {
            btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        }
        self.init(customView: btn)
    }
}

public extension Dictionary{
    func description(withLocale locale: Any?) -> String {
        var strM: String = "{\n"
        for (k,v) in self{
            strM += "\t\(k) = \(v);\n"
        }
        strM += "}\n"
        return strM
    }
}

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
public extension UIViewController{
    var backGestureEnable:Bool? {
        get{
            return self.backGestureEnable!
        }
        set{
            self.backGestureEnable = newValue
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = newValue!
        }

    }
    var naviLineHidden:Bool?{
        get{
            return self.naviLineHidden
        }
        set{
            self.naviLineHidden = newValue
            if newValue!{
                if self.navigationController?.navigationBar.responds(to: #selector(UINavigationBar.setBackgroundImage(_:for:))) ?? false {
                    let list = self.navigationController?.navigationBar.subviews
                    for obj: Any? in list ?? [Any?]() {
                        if (obj is UIImageView) {
                            let imageView = obj as? UIImageView
                            let list2 = imageView?.subviews
                            for obj2: Any? in list2 ?? [Any?]() {
                                if (obj2 is UIImageView) {
                                    let imageView2 = obj2 as? UIImageView
                                    imageView2?.isHidden = true
                                }
                            }
                        }
                    }
                }
            }else{
                if self.navigationController?.navigationBar.responds(to: #selector(UINavigationBar.setBackgroundImage(_:for:))) ?? false {
                    let list = self.navigationController?.navigationBar.subviews
                    for obj: Any? in list ?? [Any?]() {
                        if (obj is UIImageView) {
                            let imageView = obj as? UIImageView
                            let list2 = imageView?.subviews
                            for obj2: Any? in list2 ?? [Any?]() {
                                if (obj2 is UIImageView) {
                                    let imageView2 = obj2 as? UIImageView
                                    imageView2?.isHidden = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    var navBarClear:Bool?{
        get{
            return self.navBarClear
        }
        set{
            if navBarClear!{
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true;
            }else{
                self.navigationController?.navigationBar.shadowImage = UIImage.createImageWithColor(UIColor.clear)
                self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "LastMinute_TitleBar_621")
                    , for: UIBarMetrics.default)
                self.navigationController?.navigationBar.isTranslucent = false;
            }
        }
    }
    func AppRootViewController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
}

