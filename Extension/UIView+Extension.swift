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
}

