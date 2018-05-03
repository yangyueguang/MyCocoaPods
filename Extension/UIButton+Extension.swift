//
//  UIButton+Extension.swift
import UIKit
extension UIButton {
    convenience init(x: CGFloat, iconName: NSString, target: AnyObject?, action: Selector, imageEdgeInsets: UIEdgeInsets){
        self.init()
        frame = CGRect(x: x, y: 0, width: 44, height: 44)
        setImage(UIImage(named: iconName as String), for: UIControlState())
        setImage(UIImage(named: iconName as String), for: UIControlState.highlighted)
        self.imageEdgeInsets = imageEdgeInsets
        addTarget(target, action: action, for: UIControlEvents.touchUpInside)
    }
    /// 导航栏排序按钮
    convenience init(sortTarget: AnyObject?, action: Selector) {
        self.init()
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        setImage(UIImage(named: "icon_sort"), for: UIControlState())
        addTarget(sortTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    /// 导航栏返回按钮
    convenience init(backTarget: AnyObject?, action: Selector) {
        self.init()
        setImage(UIImage(named: "back"), for: UIControlState())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        addTarget(backTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    /// 导航栏取消按钮
    convenience init(cancelTarget: AnyObject?, action: Selector) {
        self.init()
        setTitle("取消", for: UIControlState())
        frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        addTarget(cancelTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    /// 选礼神器-筛选标签按钮
    convenience init(srotTagTarget: AnyObject?, action: Selector) {
        self.init()
        setBackgroundImage(UIImage.imageWithColor(UIColor.white, size: CGSize(width: 1, height: 1)), for: UIControlState())
        setBackgroundImage(UIImage.imageWithColor(UIColor(red: 251.0/255.0, green: 45.0/255.0, blue: 71.0/255.0, alpha: 1.0), size: CGSize(width: 1, height: 1)), for: UIControlState.selected)
        setBackgroundImage(UIImage.imageWithColor(UIColor.red, size: CGSize(width: 1, height: 1)), for: UIControlState.highlighted)
        setTitleColor(UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0), for: UIControlState())
        setTitleColor(UIColor.white, for: UIControlState.selected)
        setTitleColor(UIColor.white, for: UIControlState.highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor (red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        layer.borderWidth = 0.5
        addTarget(srotTagTarget, action: action, for: UIControlEvents.touchUpInside)
    }
    class func zjBarButtonItem(_ title : String,imageName : String,block:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButtonType.custom)
        button.adjustsImageWhenDisabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(title, for: UIControlState())
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0,0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.sizeToFit()
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.frame.size = CGSize(width: String.zjSizeWithString(title, font: UIFont.systemFont(ofSize: 14) , sizeWidth: 0, sizeHeight: 21) + ((button.imageView?.image?.size.width)!), height: 21)
        return button
    }
    ///自定义返回Nav按钮
    class func buttonWithBackItem() -> UIButton {
        let btn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 20))
        btn.setTitleColor(UIColor.blue, for: UIControlState())
        btn.setTitle("返回", for: UIControlState())
        return btn
    }
    //主页搜索栏
    class func createTitleButtonView(_ imageName : String,title : String,withClickBlock:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButtonType.custom)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage.init(named: imageName), for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.backgroundColor = UIColor.HEX(0x32b267)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0,0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.sizeToFit()
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center;
        button.frame.size = CGSize(width: UIScreen.main.bounds.size.width - 60, height: 30)
        return button
    }
    class func createDestinationTitleButtonView(_ imageName : String,title : String,frame : CGRect , withClickBlock:@escaping ()->Void) -> UIButton {
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = frame
        button.setTitleColor(UIColor.HEX(0xbec2c6), for: UIControlState())
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage.init(named: imageName), for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.backgroundColor = UIColor.HEX(0xe7f6f4)
        button.layer.cornerRadius = 15
        button.alpha = 0.9
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0,0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center;
        return button
    }
    //自定义按钮：
    class func createButtonWithTitle(frame:CGRect,title:String,fontSize:CGFloat,tag:Int,target:AnyObject,action:Selector) -> UIButton  {
        let  button = UIButton.init(type: UIButtonType.custom)
        button.frame = frame
        button.setTitle(title, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.tag = tag
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }
    class func createButtonWithImg(frame:CGRect,imgName:String,tag:Int,target:AnyObject,action:Selector) -> UIButton  {
        let  button = UIButton.init(type: UIButtonType.custom)
        button.frame = frame
        button.setBackgroundImage(UIImage.init(named: imgName), for: UIControlState.normal)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.tag = tag
        return button
        
    }
}
