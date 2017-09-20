//
//  NSArray+Extension.swift
//  project
//
//  Created by Super on 2017/9/15.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
extension Array{
    func description(withLocale locale: Any?) -> String {
        var strM: String = "(\n"
        for obj:Any in self{
            strM += "\t\(obj),\n"
        }
        strM += ")"
        return strM
    }
    mutating func moveObject(from: Int, to: Int) {
        if to != from {
            let obj = self[from]
            remove(at: from)
            if to >= count {
                append(obj)
            }else {
                insert(obj, at: to)
            }
        }
    }
}
