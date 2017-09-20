//
//  UIImageView+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
// MARK: - UIImageView
extension UIImageView {
    
    func roundImageView() ->UIImageView{
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        return self
    }
}
