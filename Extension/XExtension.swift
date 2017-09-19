
//
//  String+Extension.swift
//  Pods
//
//  Created by Super on 2017/9/18.
//
import Foundation
import UIKit
extension NSObject{
    ///将NSArray或者NSDictionary转化为NSString
    func jsonString() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self){
            return String(data: data, encoding: .utf8)!
        }
        return ""
    }
    func tojsonstring() -> String {
        if let data = try? JSONSerialization.data(withJSONObject: self) {
            return String(data: data, encoding: String.Encoding.utf8)!
        }
        return ""
    }
    //  哪个类调用，就返回哪个类的对象数组对应的json数组。
    class func jsonArray(withObjectArray objectArray: [Any]) -> [Any] {
        var jsonObjects = [Any]()
        for model in objectArray {
            let jsonDict: [AnyHashable: Any] = (model as AnyObject).dictionaryRepresentation()
            jsonObjects.append(jsonDict)
        }
        return jsonObjects
    }
}
extension String{
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
extension UIColor{
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
extension UIImage{
    //通过颜色来生成一个纯色图片
    class func image(from color: UIColor, size aSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: aSize.width, height: aSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    func imageByScaling(to targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage? = self
        var newImage: UIImage? = nil
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        let scaledWidth: CGFloat = targetWidth
        let scaledHeight: CGFloat = targetHeight
        let thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage?.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        return newImage!
    }
    func resizeImage(withNewSize newSize: CGSize) -> UIImage {
        let newWidth: CGFloat = newSize.width
        let newHeight: CGFloat = newSize.height
        // Resize image if needed.
        let width = size.width
        let height = size.width
        if width == 0 || height == 0 {}
        //float scale;
        if width != newWidth || height != newHeight {
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let resized: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //NSData *jpeg = UIImageJPEGRepresentation(image, 0.8);
            return resized!
        }
        return self
    }
    //  根据图片名返回一张能够自由拉伸的图
    func imageWithStrch(_ imageName: String)-> UIImage {
        let image = UIImage(named: imageName)
        // 获取原有图片的宽高的一半
        let w: CGFloat? = (image?.size.width)! * 0.5
        let h: CGFloat? = (image?.size.height)! * 0.5
        // 生成可以拉伸指定位置的图片
        let newImage: UIImage? = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(h!, w!, h!, w!), resizingMode: .stretch)
        return newImage!
    }
}
extension UILabel{
    func txtCopy(_ item: Any) {
        UIPasteboard.general.string = text
        print("________copy:\(String(describing: text))")
    }
}
extension Date{
    /*计算这个月有多少天*/
    func numberOfDaysInCurrentMonth() -> Int {
        return (Calendar.current.range(of: .day, in: .month, for: self)?.count)!
    }
    //本月开始日期
    func startOfCurrentMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    //本月结束日期
    func endOfCurrentMonth(returnEndTime:Bool = false) -> Date {
        let components = NSDateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        return Calendar.current.date(byAdding: components as DateComponents, to: startOfCurrentMonth())!
    }
    //获取这个月有多少周
    func numberOfWeeksInCurrentMonth() -> Int {
        let weekday: Int = startOfCurrentMonth().weeklyOrdinality()
        var days: Int = numberOfDaysInCurrentMonth()
        var weeks: Int = 0
        if weekday > 1 {
            weeks += 1
            days -= (7 - weekday + 1)
        }
        weeks += days / 7
        weeks += (days % 7 > 0) ? 1 : 0
        return weeks
    }
    /*计算这个月的第一天是礼拜几*/
    func weeklyOrdinality() -> Int {
        return Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: self)!
    }
    //上一个月
    func dayInThePreviousMonth() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    //下一个月
    func dayInTheFollowingMonth() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    //获取当前日期之后的几个月
    func dayInThefollowingMonth(_ month: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = month
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    //获取当前日期之后的几个天
    func dayInThe(followingDay day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = day
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    //获取当前日期之前的几个天
    func dayBeforeThe(followingDay day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = -day
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    //获取年月日对象
    func ymdComponents() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .weekday], from: self)
    }
    //NSString转NSDate
    func dateFrom(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        //  [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let destDate: Date? = dateFormatter.date(from: string)
        return destDate!
    }
    //NSDate转NSString
    func stringFrom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let destDateString: String = dateFormatter.string(from: date)
        return destDateString
    }
    static func getDayNumbertoDay(_ today: Date, beforDay beforday: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        //日历控件对象
        let components: DateComponents? = calendar.dateComponents([.day], from: today, to: beforday)
        let day: Int? = components?.day
        //两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
        return day!
    }
    //周日是“1”，周一是“2”...
    func getWeekIntValueWithDate() -> Int {
        let calendar = Calendar(identifier: .chinese)
        let comps: DateComponents? = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        return  (comps?.weekday)!
    }
    //判断日期是今天,明天,后天,周几
    func compareIfTodayWithDate() -> String {
        let todate = Date()
        let calendar = Calendar(identifier: .chinese)
        let comps_today: DateComponents? = calendar.dateComponents([.year, .month, .day, .weekday], from: todate)
        let comps_other: DateComponents? = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        //获取星期对应的数字
        let weekIntValue: Int = getWeekIntValueWithDate()
        if comps_today?.year == comps_other?.year && comps_today?.month == comps_other?.month && comps_today?.day == comps_other?.day {
            return "今天"
        }else if comps_today?.year == (comps_other?.year)! && (comps_today?.month)! == (comps_other?.month)! && ((comps_today?.day)! - (comps_other?.day)!) == -1 {
            return " 明天"
        }else if comps_today?.year == comps_other?.year && comps_today?.month == (comps_other?.month)! && ((comps_today?.day)! - (comps_other?.day)!) == -2 {
            return "后天"
        }else{
            //直接返回当时日期的字符串(这里让它返回空)
            return Date.getWeekString(fromInteger: weekIntValue)//周几
        }
    }
    //通过数字返回星期几
    static func getWeekString(fromInteger week: Int) -> String {
        var str_week: String
        switch week {
        case 1:str_week = "周日"
        case 2:str_week = "周一"
        case 3:str_week = "周二"
        case 4:str_week = "周三"
        case 5:str_week = "周四"
        case 6:str_week = "周五"
        case 7:str_week = "周六"
        default:str_week = "越界"
        }
        return str_week
    }
    
}
extension Array{
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






