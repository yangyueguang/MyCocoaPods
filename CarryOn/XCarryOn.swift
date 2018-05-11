//
//  CarryOn.swift
//  MyCocoaPods
//
//  Created by htf on 2018/5/4.
//  Copyright © 2018年 Super. All rights reserved.
import UIKit
@objcMembers
open class XCarryOn: NSObject {

}
@objcMembers
open class XPageControl: UIPageControl {
    var imagePageStateNormal: UIImage?{
        get{
            return self.imagePageStateNormal!
        }
        set{
            self.imagePageStateNormal = newValue!
            updateDots()
        }
    }
    open var imagePageStateHighlighted: UIImage?{
        get{
            return self.imagePageStateHighlighted!
        }
        set{
            self.imagePageStateHighlighted = newValue!
            updateDots()
        }
    }
    override open var currentPage: Int{
        set{
         super.currentPage = newValue
         updateDots()
        }
        get{
            return self.currentPage
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        updateDots()
    }
    private func updateDots() {
        // 更新显示所有的点按钮
        if let highlightedImage = imagePageStateHighlighted{
            for v in self.subviews{
                var image = self.imagePageStateNormal
                if self.currentPage == self.subviews.index(of: v){
                    image = highlightedImage
                }
                if v.subviews.count==0{
                    let dot = UIImageView(frame: v.bounds)
                    v.addSubview(dot)
                    dot.contentMode = .center
                    dot.image = image!
                }else{
                    let temp = v.subviews.first as? UIImageView
                    temp?.image = image
                }
            }
        }
    }
}
///让键盘右上角加个完成按钮// 键盘完成按钮
@objcMembers
open class XTextField: UITextField {
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0,width:UIScreen.main.bounds.size.width, height:30))
        toolBar.barStyle = .default
        let btnFished = UIButton(frame: CGRect(x:0,y:0,width:50,height:25))
        btnFished.setTitleColor(UIColor.init(red: 4/256.0, green: 170/256.0, blue: 174/256.0, alpha: 1), for: .normal)
        btnFished.setTitleColor(.gray,for: .highlighted)
        btnFished.setTitle("完成", for: .normal)
        btnFished.addTarget(self, action: Selector(("finishTapped:")), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btnFished)
        let space = UIView(frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.size.width - btnFished.frame.width - 30, height:25))
        let item = UIBarButtonItem(customView: space)
        toolBar.setItems([item,item2], animated: true)
        self.inputAccessoryView = toolBar
    }
    func finishTapped(sender:UIButton){
        self.resignFirstResponder()
    }
}
