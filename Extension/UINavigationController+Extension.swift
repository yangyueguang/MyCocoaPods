
//
//  UINavigationController+Extension.swift
import Foundation
import UIKit
extension UINavigationController  {
    class func zjPopViewControllerAnimated(_ nav : UINavigationController) {
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationDuration(0.75)
        UIView.setAnimationTransition(UIViewAnimationTransition.none, for: nav.view, cache: false)
        UIView.commitAnimations()
        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(0.375)
        nav.popViewController(animated: false)
        UIView.commitAnimations()
        nav.popViewController(animated: true)
    }
}
