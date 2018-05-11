//
//  Dictionary+Extension.swift
import Foundation
public extension Dictionary{
    func description(withLocale locale: Any?) -> String {
        var strM: String = "{\n"
        for (k,v) in self{
            strM += "\t\(k) = \(v);\n"
        }
        strM += "}\n"
        return strM
    }
}
