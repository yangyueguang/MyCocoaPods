//
//  OtherExtensions.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/3.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Foundation
public extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
}
public extension URL {
    var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return [:] }
        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
}
public extension FileManager {
    class func url(for dictionary: FileManager.SearchPathDirectory) -> URL?{
        return self.default.urls(for: dictionary, in: .userDomainMask).last
    }
    class func path(for directory: FileManager.SearchPathDirectory) -> String?{
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first
    }
    /// 清理缓存
    class func clearCache() {
        let domain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: domain!)
    }
    /// 获取文件大小
    class func fileSizeAtPath(_ filePath:String) -> Double{
        let manager = FileManager.default
        do {
            let attr = try manager.attributesOfItem(atPath:filePath)
            return attr[FileAttributeKey.size] as! Double
        } catch  {
            return 0
        }
    }
    /// 获取文件夹大小
    class func folderSizeAtPath(_ folderPath:String) -> Double{
        let manager = FileManager.default
        var folderSize = 0.0
        var isDir: ObjCBool = true
        if manager.fileExists(atPath: folderPath, isDirectory: &isDir){
            if isDir.boolValue{
                let childFilesEnumerator = manager.enumerator(atPath: folderPath)
                while let fileName = childFilesEnumerator?.nextObject(){
                    let absolutePath = "\(folderPath)\(fileName)"
                    folderSize += self.folderSizeAtPath(absolutePath)
                }
            }else{
                folderSize += fileSizeAtPath(folderPath)
            }
        }
        return folderSize
    }
}

public extension UIFont {

}

public extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(CGFloat(red), CGFloat(green), CGFloat(blue), alpha)
    }
    convenience init(_ R: CGFloat,_ G: CGFloat,_ B: CGFloat,_ A: CGFloat = 1) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
    }
    class var random: UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    var hexString: String {
        let components: [Int] = {
            let c = cgColor.components!
            let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
}

class ClosureWrapper: NSObject {
    let closureCallBack: () -> Void
    init(callBack: @escaping () -> Void) {
        closureCallBack = callBack
    }
    @objc open func invoke() {
        closureCallBack()
    }
}

var associatedClosure: UInt8 = 0
public extension UIControl {
    func addAction(_ events: UIControl.Event, closure: @escaping () -> Void) {
        let wrapper = ClosureWrapper.init(callBack: closure)
        addTarget(wrapper, action: #selector(wrapper.invoke), for: events)
        objc_setAssociatedObject(self, &associatedClosure, wrapper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
//FIXME: 以下是UIKit的扩展
public extension UILabel {
    convenience init(frame: CGRect, font: UIFont, color: UIColor, text: String?, lineSpace: CGFloat = -1, alignment: NSTextAlignment = .left, lines: Int = 0, shadowColor: UIColor = UIColor.clear) {
        self.init(frame: frame)
        self.font = font
        self.text = text
        self.backgroundColor = UIColor.clear
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = lines
        self.shadowColor = shadowColor
        if lineSpace > 0 {
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = lineSpace
            let attributedString = NSMutableAttributedString.init(string: text ?? "", attributes: [NSAttributedString.Key.paragraphStyle:paragraphStye])
            self.attributedText = attributedString
        }
    }
    /// 复制文字到剪贴板
    @objc func txtCopy(_ item: Any) {
        UIPasteboard.general.string = text
    }
    /// 添加长按复制的响应
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
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

public extension UITextField {
    func placeholderColor(_ color : UIColor) {
        self.setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
    convenience init(frame: CGRect, font: UIFont?, color: UIColor?, holder: String?, text: String?) {
        self.init(frame: frame)
        keyboardType = .default
        borderStyle = .none
        clearButtonMode = .whileEditing
        textColor = color
        placeholder = holder
        self.font = font
        isSecureTextEntry = false
        returnKeyType = .done
        self.text = text
        contentVerticalAlignment = .center
    }
}

public extension UIImageView {
    func imageWithURL(_ url: String) {
        let task = URLSession.shared.dataTask(with:URL(string: url)!, completionHandler: { (data, respons, eror) -> Void in
            guard let data = data else { return }
            DispatchQueue.main.async(execute: {
                self.image = UIImage(data: data)
            })
        })
        task.resume();
    }
}

public extension UIScrollView {

}

public extension UISearchBar {
    convenience init(delegate: UISearchBarDelegate?, backgroundColor: UIColor?, backgroundImage: UIImage?, holder: String?) {
        self.init()
        self.delegate = delegate
        placeholder = holder
        tintColor = UIColor.white
        barStyle = UIBarStyle.blackTranslucent
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        self.backgroundImage = backgroundImage
        for subView in subviews {
            for v in subView.subviews where v.isKind(of: UITextField.self) {
                v.backgroundColor = backgroundColor
            }

        }
    }
}

public extension UIAlertController {
    convenience init(_ title:String,_ message:String,T1:String,T2:String,confirm1: @escaping () -> Void,confirm2: @escaping () -> Void){
        self.init(title: title, message: message, preferredStyle: .alert)
        let a = UIAlertAction(title: T1, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            confirm1()
        })
        let b = UIAlertAction(title: T2, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            confirm2()
        })
        self.addAction(a)
        self.addAction(b)
    }
}

public extension UIBarButtonItem {
    /// 用Button生成的自定义View
    convenience init(title: String?, img:UIImage?, HImg: UIImage?, target: AnyObject?, action: Selector?, size: CGSize = CGSize(width: 44, height: 44)){
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

public extension UINavigationController  {
    func popSelf() {
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
        UIView.setAnimationDuration(0.75)
        UIView.setAnimationTransition(UIView.AnimationTransition.none, for: self.view, cache: false)
        UIView.commitAnimations()
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.375)
        self.popViewController(animated: false)
        UIView.commitAnimations()
        self.popViewController(animated: true)
    }
}

public extension UIViewController{
    var rootController: UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    class func initFromNib() -> UIViewController {
        let nib = Bundle(for: self)
        return self.init(nibName: self.nameOfClass, bundle: nib)
    }

    /// 是否支持手势返回
    func setBackGestureEnable(_ enable: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    /// 导航栏下的横线是否隐藏
    func setNaviLineHidden(_ hidden: Bool) {
        guard let list = self.navigationController?.navigationBar.subviews else { return }
        for v in list where v is UIImageView {
            for img in v.subviews where img is UIImageView {
                img.isHidden = hidden
            }
        }
    }
    /// 导航栏是否透明
    func setNavBarClear(_ clear: Bool) {
        if clear{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true;
        }else{
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clear)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "LastMinute_TitleBar_621")
                , for: UIBarMetrics.default)
            self.navigationController?.navigationBar.isTranslucent = false;
        }
    }
}
