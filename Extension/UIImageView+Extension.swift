//
//  UIImageView+Extension.swift
import Foundation
import UIKit
extension UIImageView {
    func roundImageView() ->UIImageView{
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        return self
    }
}
