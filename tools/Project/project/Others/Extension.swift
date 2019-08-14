//
//  Extension.swift
//  project
//
//  Created by Chao Xue 薛超 on 2019/7/31.
//  Copyright © 2019 Super. All rights reserved.
//
import UIKit
import Foundation
extension UITableView {

}
extension Collection {
    subscript (i index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
