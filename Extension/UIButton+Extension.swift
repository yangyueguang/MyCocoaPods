//
//  UIButton+Extension.swift
import UIKit
public extension UIButton {
    convenience init(x: CGFloat, iconName: NSString, target: AnyObject?, action: Selector, imageEdgeInsets: UIEdgeInsets){
        self.init()
        frame = CGRect(x: x, y: 0, width: 44, height: 44)
        setImage(UIImage(named: iconName as String), for: UIControl.State())
        setImage(UIImage(named: iconName as String), for: UIControl.State.highlighted)
        self.imageEdgeInsets = imageEdgeInsets
        addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
    /// 导航栏排序按钮
    convenience init(sortTarget: AnyObject?, action: Selector) {
        self.init()
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        setImage(UIImage(named: "icon_sort"), for: UIControl.State())
        addTarget(sortTarget, action: action, for: UIControl.Event.touchUpInside)
    }
    /// 导航栏返回按钮
    convenience init(backTarget: AnyObject?, action: Selector) {
        self.init()
        setImage(UIImage(named: "back"), for: UIControl.State())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        addTarget(backTarget, action: action, for: UIControl.Event.touchUpInside)
    }
    /// 导航栏取消按钮
    convenience init(cancelTarget: AnyObject?, action: Selector) {
        self.init()
        setTitle("取消", for: UIControl.State())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        addTarget(cancelTarget, action: action, for: UIControl.Event.touchUpInside)
    }
    /// 选礼神器-筛选标签按钮
    convenience init(srotTagTarget: AnyObject?, action: Selector) {
        self.init()
        setBackgroundImage(UIImage.imageWithColor(UIColor.white, size: CGSize(width: 1, height: 1)), for: UIControl.State())
        setBackgroundImage(UIImage.imageWithColor(UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0), size: CGSize(width: 1, height: 1)), for: UIControl.State.selected)
        setBackgroundImage(UIImage.imageWithColor(UIColor.red, size: CGSize(width: 1, height: 1)), for: UIControl.State.highlighted)
        setTitleColor(UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), for: UIControl.State())
        setTitleColor(UIColor.white, for: UIControl.State.selected)
        setTitleColor(UIColor.white, for: UIControl.State.highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor (red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        layer.borderWidth = 0.5
        addTarget(srotTagTarget, action: action, for: UIControl.Event.touchUpInside)
    }
    class func zjBarButtonItem(_ title : String,imageName : String,block:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.adjustsImageWhenDisabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(title, for: UIControl.State())
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0,right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.sizeToFit()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setImage(UIImage(named: imageName), for: UIControl.State())
        button.frame.size = CGSize(width: String.zjSizeWithString(title, font: UIFont.systemFont(ofSize: 14) , sizeWidth: 0, sizeHeight: 21) + ((button.imageView?.image?.size.width)!), height: 21)
        return button
    }
    ///自定义返回Nav按钮
    class func buttonWithBackItem() -> UIButton {
        let btn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 20))
        btn.setTitleColor(UIColor.blue, for: UIControl.State())
        btn.setTitle("返回", for: UIControl.State())
        return btn
    }
    //主页搜索栏
    class func createTitleButtonView(_ imageName : String,title : String,withClickBlock:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage.init(named: imageName), for: UIControl.State())
        button.setTitle(title, for: UIControl.State())
        button.backgroundColor = UIColor.HEX(0x32b267)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0,right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.sizeToFit()
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center;
        button.frame.size = CGSize(width: UIScreen.main.bounds.size.width - 60, height: 30)
        return button
    }
    class func createDestinationTitleButtonView(_ imageName : String,title : String,frame : CGRect , withClickBlock:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.setTitleColor(UIColor.HEX(0xbec2c6), for: UIControl.State())
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage.init(named: imageName), for: UIControl.State())
        button.setTitle(title, for: UIControl.State())
        button.backgroundColor = UIColor.HEX(0xe7f6f4)
        button.layer.cornerRadius = 15
        button.alpha = 0.9
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0,right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center;
        return button
    }
    //自定义按钮：
    class func createButtonWithTitle(frame:CGRect,title:String,fontSize:CGFloat,tag:Int,target:AnyObject,action:Selector) -> UIButton  {
        let  button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.setTitle(title, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.tag = tag
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }
    class func createButtonWithImg(frame:CGRect,imgName:String,tag:Int,target:AnyObject,action:Selector) -> UIButton  {
        let  button = UIButton.init(type: UIButton.ButtonType.custom)
        button.frame = frame
        button.setBackgroundImage(UIImage.init(named: imgName), for: UIControl.State.normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.tag = tag
        return button
        
    }
}
