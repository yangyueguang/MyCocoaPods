
//
//  String+Extension.swift
//  project
//
//  Created by Super on 2017/9/13.
//  Copyright © 2017年 Super. All rights reserved.
//

import Foundation
import UIKit
// MARK: - String
extension String {
    
    static func zjSizeWithString(_ str : String,font : UIFont, sizeWidth : CGFloat, sizeHeight : CGFloat) -> CGFloat {
        
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = str.boundingRect(with: CGSize(width: sizeWidth, height: 8000), options: option, attributes: attributes, context: nil)
        return sizeWidth == 0 ? rect.size.width : rect.size.height
    }
    
    

    
    static func getSeqNo() -> String{
        
        return  String(arc4random()%89999999+10000000)
    }
    
    
    
    static func getWeekName(_ englishName : String) -> String{
        
        switch englishName{
            
        case "Monday"   :return "星期一"
        case "Tuesday"  :return "星期二"
        case "Wednesday":return "星期三"
        case "Thursday" :return "星期四"
        case "Friday"   :return "星期五"
        case "Saturday" :return "星期六"
        case "Sunday"   :return "星期日"
        default:return""
            
        }
        
    }
    
    /**
     获取唯一标示UUID
     
     - returns: 返回UUID
     */
    static func getUUID() -> String{
        
        let uuid : UUID = UIDevice.current.identifierForVendor!
        let uu :String = "\(uuid)"
        let array = uu.components(separatedBy: ">")
        
        let arrayNext  = array[1].components(separatedBy: "-")
        
        let lastArray = "\((arrayNext[0] )+(arrayNext[1] )+(arrayNext[2] )+(arrayNext[3] )+(arrayNext[4] ))".components(separatedBy: " ")
        
        return "\((lastArray[0] )+(lastArray[1] ))"
        
    }
    
    
    /**
     获取当前时间戳
     
     - returns: 返回当前时间戳
     */
    static func getDate() -> String{
        
        let date:Foundation.Date = Foundation.Date()
        
        let array = "\(date.timeIntervalSince1970)".components(separatedBy: ".")
        
        return "\(array[0])"
    }
    
    /**
     计算字符串高度
     
     - parameter text:    计算文字
     - parameter theFont: 文字大小
     - parameter width:   文字宽度
     
     - returns: 文字高度
     */
    static func contentStringFrame(_ label : UILabel,text : String,theFont : CGFloat,width : CGFloat , height : CGFloat) -> CGFloat{
        
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        label.font = UIFont.systemFont(ofSize: theFont)
        
        label.numberOfLines = 0
        
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        let boundingRect : CGRect = text.boundingRect(with: CGSize(width: CGFloat(width), height: 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: theFont)], context: nil)
        
        return width == 0 ? boundingRect.width : boundingRect.height
    }
    
    /**<判断字符串是否为空*/
    func isNullOrEmpty()->Bool
    {
        if(self.isEmpty)
        {
            return true;
        }
        else
        {
            if(self.characters.count>0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
    
    /**
     在固定宽度情况下，获取文字的Size
     
     - parameter width:      固定的宽度
     - parameter attributes: 文字属性
     
     - returns: CGSize
     */
    func  sizeOfString (constrainedToWidth width: CGFloat, attributes : [String: AnyObject]?) -> CGSize {
        return  NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: attributes,
                                                    context: nil).size
        
        
        
    }
    func sizeOfString(font:UIFont,maxSize:CGSize) -> CGSize{
        let attrs = [NSFontAttributeName : font];
        return NSString(string: self).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    /**
     在固定高度情况下，获取文字的Size
     
     - parameter width:      固定的高度
     - parameter attributes: 文字属性
     
     - returns: CGSize
     */
    func  sizeOfString (constrainedToHeight height: CGFloat, attributes : [String: AnyObject]?) -> CGSize {
        return NSString(string: self).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                   attributes: attributes,
                                                   context: nil).size
    }
    
    

    
    //给字符串进行base64加密：
    func base64Encoded() -> String{
        
        let data:Data! = self.data(using: .utf8)
        let base64Str = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64Str
    }
    //给字符串进行base64解密：
    func base64Decoded() -> String {
        
        let data:Data! = Data.init(base64Encoded: self)
        let decodedStr = String.init(data: data!, encoding: .utf8)
        return decodedStr!
        
    }
    
    
    func isPhone()->Bool
    {
        let regex = try! NSRegularExpression(pattern: "^1[0-9]{10}$",
                                             options: [.caseInsensitive])
        
        return regex.firstMatch(in: self, options:[],
                                range: NSMakeRange(0, utf16.count)) != nil
    }
    
    /// 给当前文件追加文档路径
    func yw_appendDocumentDir() -> String {
        let dir: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        return URL(fileURLWithPath: dir!).appendingPathComponent(self).absoluteString
    }

    

    
   
    /// 给当前文件追加缓存路径
    func yw_appendCacheDir() -> String {
        let dir: String? = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        return URL(fileURLWithPath: dir!).appendingPathComponent(self).absoluteString
    }
    
    
    
    /// 给当前文件追加临时路径
    func yw_appendTempDir() -> String {
        let dir: String = NSTemporaryDirectory()
        return URL(fileURLWithPath: dir).appendingPathComponent(self).absoluteString
    }

   


    //    //给字符串进行MD5加密  返回小写 32位
    var md5OfString :String {
        
        let cString = self.cString(using: String.Encoding.utf8)
        let length = CUnsignedInt(
            self.lengthOfBytes(using: String.Encoding.utf8)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(
            capacity: Int(CC_MD5_DIGEST_LENGTH)
        )
        CC_MD5(cString!, length, result)
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15])
    }

    func replaceControlString() -> String {
        var tempStr: String = self
        tempStr = tempStr.replacingOccurrences(of: "\\", with: "\\\\")
        tempStr = tempStr.replacingOccurrences(of: "\r", with: "\\t")
        tempStr = tempStr.replacingOccurrences(of: "\t", with: "\\r")
        tempStr = tempStr.replacingOccurrences(of: "\n", with: "\\n")
        tempStr = tempStr.replacingOccurrences(of: "\"", with: "\\\"")
        return tempStr
    }
    func notEmptyOrNull() -> Bool {
        if (self == "") || (self == "null") || (self == "\"\"") || (self == "''") {
            return false
        }
        return true
    }
    func replaceTime() -> String {
        var tempStr: String = self
        tempStr = (tempStr as NSString).replacingOccurrences(of: "-", with: "年", options: [], range: NSRange(location: 0, length: 5))
        tempStr = tempStr.replacingOccurrences(of: "-", with: "月")
        tempStr = tempStr + ("日")
        return tempStr
    }
    /** 查找并返回第一个匹配的文本内容 */
    func firstMatch(withPattern pattern: String) -> String {
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        let result: NSTextCheckingResult? = regex?.firstMatch(in: self, range: NSRange(location: 0, length: pattern.utf8.count))
        if result != nil {
            let r: NSRange? = result?.rangeAt(1)
            return (self as NSString).substring(with: r!)
        }else {
            print("没有找到匹配内容 \(pattern)")
            return ""
        }
    }
    /** 查找多个匹配方案结果 */
    func matches(withPattern pattern: String) -> [Any] {
        var error: Error? = nil
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        if error != nil {
            print("匹配方案错误:\(String(describing: error?.localizedDescription))")
            return []
        }
        return (regex?.matches(in: self, range: NSRange(location: 0, length: pattern.utf8.count)))!
    }

}

