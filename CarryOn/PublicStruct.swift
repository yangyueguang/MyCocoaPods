//
//  PublicStruct.swift
//  MyCocoaPods
//
//  Created by Chao Xue 薛超 on 2018/12/12.
//  Copyright © 2018 Super. All rights reserved.
//

import Foundation
//MARK: 正则表达式
public enum Regular: String {
    case double = "-?([0-9]\\d*\\.?\\d*)"
    case int = "-?([0-9]*)"
    case phone = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
    case email = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
    case binary16 = "^#?([a-f0-9]{6}|[a-f0-9]{3})$" // 16进制
    case url = "[a-zA-z]+://[^\\s]*"
    case chinese = "^[\u{2E80}-\u{9FFF}]+$"
    case div = "^<([a-z]+)([^<]+)*(?:>(.*)</1>|\\s+/>)$"
    case userName = "[0-9A-Za-z]*"
    case name = "^[\u{4E00}-\u{9FA5}A-Za-z0-9_]+$"
    case domain = "[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?"
    case idCard = "^\\d{15}|\\d{18}$"
    case xml = "^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]$"
    case QQ = "[1-9][0-9]{4,}"
    case ip = "\\d+\\.\\d+\\.\\d+\\.\\d+"
    case postCode = "[1-9]\\d{5}(?!\\d)" // 邮编
}
/// 系统路径
public struct XPath {
    public let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    public let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let caches = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    public let temp = NSTemporaryDirectory()
    public let home = NSHomeDirectory()
}
/// 文件类型
public enum FileType:String {
    case video = "video"
    case gif = "gif"
    case image = "image"
    case text = "text"
    case html = "html"
}
