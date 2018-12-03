//
//  UIView+Extension.swift
import UIKit
import Foundation
public extension UIView  {
    func x()->CGFloat{
        return self.frame.origin.x
    }
    func right()-> CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
    func y()->CGFloat{
        return self.frame.origin.y
    }
    func bottom()->CGFloat{
        return self.frame.origin.y + self.frame.size.height
    }
    func width()->CGFloat{
        return self.frame.size.width
    }
    func height()-> CGFloat{
        return self.frame.size.height
    }
    func setX(_ x: CGFloat){
        var rect:CGRect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    func setSize(_ size : CGSize) -> Void {
        let size = self.frame.size
        self.frame.size = size
    }
    func setRight(_ right: CGFloat){
        var rect:CGRect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    func setY(_ y: CGFloat){
        var rect:CGRect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    func setBottom(_ bottom: CGFloat){
        var rect:CGRect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    func setWidth(_ width: CGFloat){
        var rect:CGRect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    func setHeight(_ height: CGFloat){
        var rect:CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    //控件居中
    func center(_ view : UIView) -> Void {
        self.center = CGPoint(x: view.center.x, y: self.center.y)
    }
    func addSubviews(_ views:[UIView]) {
        for v in views {
            self.addSubview(v)
        }
    }
    func viewAddTarget(_ target : AnyObject,action : Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }

    /// 类似qq聊天窗口的抖动效果
    func shakeAnimation() {
        let t: CGFloat = 5.0
        let translateRight = CGAffineTransform.identity.translatedBy(x: t, y: 0.0)
        let translateLeft = CGAffineTransform.identity.translatedBy(x: -t, y: 0.0)
        let translateTop = CGAffineTransform.identity.translatedBy(x: 0.0, y: 1)
        let translateBottom = CGAffineTransform.identity.translatedBy(x: 0.0, y: -1)
        self.transform = translateLeft
        UIView.animate(withDuration: 0.07, delay: 0.0, options: .autoreverse, animations: {
            UIView.setAnimationRepeatCount(2.0)
            self.transform = translateRight
        }) { finished in
            UIView.animate(withDuration: 0.07, animations: {
                self.transform = translateBottom
            }) { finished in
                UIView.animate(withDuration: 0.07, animations: {
                    self.transform = translateTop
                }) { finished in
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: .beginFromCurrentState, animations: {
                        self.transform = .identity //回到没有设置transform之前的坐标
                    })
                }
            }
        }
    }
    //view 左右抖动
    func leftRightAnimation() {
        let t: CGFloat = 5.0
        let translateRight = CGAffineTransform.identity.translatedBy(x: t, y: 0.0)
        let translateLeft = CGAffineTransform.identity.translatedBy(x: -t, y: 0.0)
        self.transform = translateLeft
        UIView.animate(withDuration: 0.07, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            UIView.setAnimationRepeatCount(2.0)
            self.transform = translateRight
        }) { finished in
            if finished {
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .beginFromCurrentState, animations: {
                    self.transform = .identity
                })
            }
        }
    }


}

