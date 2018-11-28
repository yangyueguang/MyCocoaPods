//
//  NSFileManager+Extension.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/11/28.
//  Copyright © 2018 Super. All rights reserved.
//

import Foundation
import UIKit
extension FileManager {


    class func url(for dictionary: FileManager.SearchPathDirectory) -> URL?{
       return self.default.urls(for: dictionary, in: .userDomainMask).last
    }

    class func path(for directory: FileManager.SearchPathDirectory) -> String?{
        return NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first
    }

}
