
//
//  String+Extension.swift
import Foundation
import UIKit
public extension String {
    /// 随机码
    static var seqNo: String{
        return  String(arc4random()%89999999+10000000)
    }
    /// UUID
    static var uuid: String {
        let uuid : UUID = UIDevice.current.identifierForVendor!
        let uu :String = "\(uuid)"
        let array = uu.components(separatedBy: ">")
        let arrayNext  = array[1].components(separatedBy: "-")
        let lastArray = "\((arrayNext[0] )+(arrayNext[1] )+(arrayNext[2] )+(arrayNext[3] )+(arrayNext[4] ))".components(separatedBy: " ")
        return "\((lastArray[0] )+(lastArray[1] ))"
    }
    /// 判断字符串中是否有中文
    func isHaveChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true }
        }
        return false
    }
    public var isEmoji: Bool {
        let scalarValue = unicodeScalars.first!.value
        switch scalarValue {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000...0x1F77F, // Emoticons
        0x2100...0x27BF, // Misc symbols and Dingbats
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default:
            return false
        }
    }
    /// 将中文字符串转换为拼音
    func pinyin(hasBlank: Bool = false) -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }

    /// 获取首字母
    func firstLetter(lowercased: Bool = false) -> String {
        let pinyin = self.pinyin(hasBlank: true).capitalized
        var headPinyinStr = ""
        if pinyin.count > 0 {
            headPinyinStr.append(pinyin.first!)
        }
        return lowercased ? headPinyinStr.lowercased() : headPinyinStr
    }

    /// 是否是空或空串
    static func isNullOrEmpty(_ string: String?) -> Bool {
        if let str = string, !str.isEmpty {
            return false
        } else {
            return true
        }
    }

    func createQR() -> UIImage {
        let stringData = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 200, y: 200))))
        return codeImage
    }

    /// 获取字符串占据尺寸
    func bounds(_ maxSize: CGSize, attributes : [NSAttributedString.Key: Any]?) -> CGRect {
        return  NSString(string: self).boundingRect(with: maxSize,options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: attributes,context: nil)
    }
    /// 给字符串进行base64加密：
    func base64Encoded() -> String{
        let data:Data! = self.data(using: .utf8)
        let base64Str = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        return base64Str
    }
    /// 给字符串进行base64解密：
    func base64Decoded() -> String {
        let data:Data! = Data.init(base64Encoded: self)
        let decodedStr = String.init(data: data!, encoding: .utf8)
        return decodedStr!
    }
    /// 是否是手机号
    func isPhone()->Bool{
        let regex = try! NSRegularExpression(pattern: "^1[0-9]{10}$",options: [.caseInsensitive])
        return regex.firstMatch(in: self, options:[],range: NSMakeRange(0, utf16.count)) != nil
    }

    //    //给字符串进行MD5加密  返回小写 32位
//    var md5OfString :String {
//        let cString = self.cString(using: String.Encoding.utf8)
//        let length = CUnsignedInt(
//            self.lengthOfBytes(using: String.Encoding.utf8)
//        )
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(
//            capacity: Int(CC_MD5_DIGEST_LENGTH)
//        )
//        CC_MD5(cString!, length, result)
//        return String(format:
//            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                      result[0], result[1], result[2], result[3],
//                      result[4], result[5], result[6], result[7],
//                      result[8], result[9], result[10], result[11],
//                      result[12], result[13], result[14], result[15])
//    }
    /// 替换控制字符
    func replaceControlString() -> String {
        var tempStr: String = self
        tempStr = tempStr.replacingOccurrences(of: "\\", with: "\\\\")
        tempStr = tempStr.replacingOccurrences(of: "\r", with: "\\t")
        tempStr = tempStr.replacingOccurrences(of: "\t", with: "\\r")
        tempStr = tempStr.replacingOccurrences(of: "\n", with: "\\n")
        tempStr = tempStr.replacingOccurrences(of: "\"", with: "\\\"")
        return tempStr
    }

    /// 查找并返回第一个匹配的文本内容
    func firstMatch(_ pattern: String) -> String {
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        let result: NSTextCheckingResult? = regex?.firstMatch(in: self, range: NSRange(location: 0, length: pattern.utf8.count))
        if result != nil {
            let r: NSRange? = result?.range(at: 1)
            return (self as NSString).substring(with: r!)
        }else {
            return ""
        }
    }
    /// 查找多个匹配方案结果
    func matches(_ pattern: String) -> [Any] {
        let error: Error? = nil
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        if error != nil {
            return []
        }
        return (regex?.matches(in: self, range: NSRange(location: 0, length: pattern.utf8.count)))!
    }
}

public extension NSAttributedString {
    /// 增加属性字符串
    func applying(attributes: [NSAttributedString.Key: Any], match pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }
        return result
    }
    /// 下划线
    func bottomLine(_ color: UIColor, match pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        for match in matches {
            let number = NSNumber(value: NSUnderlineStyle.single.rawValue as Int)
            result.addAttribute(NSAttributedString.Key.underlineStyle, value: number, range: match.range)
            result.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)
        }
        return result
    }
    /// 删除线
    func deleteLine(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let result = NSMutableAttributedString(attributedString: self)
        result.addAttributes(attributes, range: NSRange(0..<length))
        return result
    }

}
