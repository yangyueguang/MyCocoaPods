//
//  UIBarButtonItem+Extension.swift
import UIKit
public extension UIBarButtonItem {
    convenience init(gifTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "feed_signin"), for: UIControl.State())
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        btn.addTarget(gifTarget, action: action, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    /// 搜索
    convenience init(searchTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage(named: "icon_navigation_search"), for: UIControl.State())
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        btn.addTarget(searchTarget, action: action, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    /// 选礼神器
    convenience init(chooseGifTarget: AnyObject?, action: Selector){
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        btn.setTitle("选礼神器", for: UIControl.State())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.setTitleColor(UIColor.white, for: UIControl.State())
        btn.addTarget(chooseGifTarget, action: action, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    class func barButtonItemWithImg(_ image : UIImage!, selectorImg : UIImage?, target : AnyObject!, action : Selector!) -> UIBarButtonItem {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -10, y: 0, width: 40, height: 40)
        view.addSubview(imageView)
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        return UIBarButtonItem(customView: view)
    }
}
