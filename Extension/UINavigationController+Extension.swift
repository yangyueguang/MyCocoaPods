
//
//  UINavigationController+Extension.swift
import Foundation
import UIKit
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
