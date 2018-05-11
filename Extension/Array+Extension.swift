//
//  NSArray+Extension.swift
import Foundation
public extension Array{
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
