//
//  Dictionary+Extension.swift
//  project
//
//  Created by Super on 2017/9/15.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
extension Dictionary{
    func description(withLocale locale: Any?) -> String {
        var strM: String = "{\n"
        for (k,v) in self{
            strM += "\t\(k) = \(v);\n"
        }
        strM += "}\n"
        return strM
    }
}
