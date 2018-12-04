//
//  UIView+Extension.swift
import UIKit
import Foundation
public extension UIView  {
    var x: CGFloat {
        set {
            self.frame = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.x
        }
    }
    var y: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.y
        }
    }
    var width: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
        get {
            return frame.size.width
        }
    }
    var height: CGFloat {
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
        get {
            return frame.size.height
        }
    }
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: right - frame.origin.x, height: frame.size.height)
        }
    }
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: bottom - frame.origin.y)
        }
    }
    var size: CGSize {
        set {
            self.frame.size = size
        }
        get {
            return frame.size
        }
    }

    func alignmentLeft(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: view.x + offset, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }
    func alignmentRight(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: view.right - self.width + offset, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }
    func alignmentTop(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: frame.origin.x, y: view.y + offset, width: frame.size.width, height: frame.size.height)
    }
    func alignmentBottom(_ view: UIView, _ offset: CGFloat = 0) {
        self.frame = CGRect(x: frame.origin.x, y: view.bottom - frame.size.height + offset, width: frame.size.width, height: frame.size.height)
    }
    func alignmentHorizontal(_ view: UIView) {
        self.center = CGPoint(x: view.center.x, y: center.y)
    }
    func alignmentVertical(_ view: UIView) {
        self.center = CGPoint(x: center.x, y: view.center.y)
    }
    /// 变圆
    func round() {
        layer.masksToBounds = true
        layer.cornerRadius = size.width / 2
    }
    /// 批量添加子视图
    func addSubviews(_ views:[UIView]) {
        for v in views {
            self.addSubview(v)
        }
    }
    /// 添加点击响应
    func add(_ target: AnyObject, action: Selector) {
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
    /// 左右抖动
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
