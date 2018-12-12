//
//  ReusableView+Extension.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/12.
//  Copyright © 2018 Super. All rights reserved.
//
import UIKit
import Foundation
public extension UICollectionViewCell {
}
public extension UICollectionReusableView {
    class var identifier: String {
        return self.nameOfClass
    }
    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}
public extension UICollectionView {
    func register(_ view: UICollectionReusableView.Type, isCell: Bool = true,isHeader: Bool = true, isNib: Bool = false) {
        if isCell {
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view.self)), forCellWithReuseIdentifier: view.identifier)
            }else{
                self.register(view.self, forCellWithReuseIdentifier: view.identifier)
            }
        }else{
            if isNib {
                self.register(UINib(nibName: view.nameOfClass, bundle: Bundle(for: view.self)), forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }else{
                self.register(view.self, forSupplementaryViewOfKind: isHeader ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
            }
        }
    }
}
public extension UITableViewCell {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}
public extension UITableViewHeaderFooterView {
    class var identifier: String {
        return self.nameOfClass
    }

    class var bundle: Bundle? {
        return Bundle(for: self)
    }
}

public extension UITableView {
    func register(_ cell: UITableViewCell.Type, isNib: Bool = false) {
        if isNib {
            self.register(UINib(nibName: cell.nameOfClass, bundle: cell.bundle), forCellReuseIdentifier: cell.identifier)
        }else{
            self.register(cell.self, forCellReuseIdentifier: cell.identifier)
        }
    }
    func register(_ headFoot: UITableViewHeaderFooterView.Type, isNib: Bool = false) {
        if isNib {
            self.register(UINib(nibName: headFoot.nameOfClass, bundle: headFoot.bundle), forHeaderFooterViewReuseIdentifier: headFoot.identifier)
        }else{
            self.register(headFoot.self, forHeaderFooterViewReuseIdentifier: headFoot.identifier)
        }
    }
}
