
//
//  Date+Extension.swift
import Foundation
// MARK: - 计算
private var moren :TimeInterval = Foundation.Date().timeIntervalSince1970
public extension Date {
    var timeInterval:TimeInterval {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &moren) as? TimeInterval else {
                return Foundation.Date().timeIntervalSince1970
            }
             return isFinished
        }
        set {
            objc_setAssociatedObject(self, &moren, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    mutating func addDay(_ day:Int) {
        timeInterval += Double(day) * 24 * 3600
    }
    mutating func reduceDay(_ day:Int) {
        timeInterval -= Double(day) * 24 * 3600
    }
    mutating func addHour(_ hour:Int) {
        timeInterval += Double(hour) * 3600
    }
    mutating func addMinute(_ minute:Int) {
        timeInterval += Double(minute) * 60
    }
    mutating func addSecond(_ second:Int) {
        timeInterval += Double(second)
    }
    mutating func addMonth(month m:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        let era = year / 100
        if #available(iOS 8.0, *) {
            if let date = (Calendar.current as NSCalendar).date(era: era, year: year, month: month + m, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
                timeInterval = date.timeIntervalSince1970
            } else {
                timeInterval += Double(m) * 30 * 24 * 3600
            }
        } else {
            // Fallback on earlier versions
        }
    }
    mutating func addYear(year y:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        let era = year / 100
        if #available(iOS 8.0, *) {
            if let date = (Calendar.current as NSCalendar).date(era: era, year: year + y, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
                timeInterval = date.timeIntervalSince1970
            } else {
                timeInterval += Double(y) * 365 * 24 * 3600
            }
        } else {
            // Fallback on earlier versions
        }
    }
    // for example : let (year, month, day) = date.getDay()
    func getDay() -> (year:Int, month:Int, day:Int) {
        var year:Int = 0, month:Int = 0, day:Int = 0
        let date = Foundation.Date(timeIntervalSince1970: timeInterval)
        if #available(iOS 8.0, *) {
            (Calendar.current as NSCalendar).getEra(nil, year: &year, month: &month, day: &day, from: date)
        } else {
            // Fallback on earlier versions
        }
        return (year, month, day)
    }
    // for example : let (hour, minute, second) = date.getTime()
    func getTime() -> (hour:Int, minute:Int, second:Int) {
        var hour:Int = 0, minute:Int = 0, second:Int = 0
        let date = Foundation.Date(timeIntervalSince1970: timeInterval)
        if #available(iOS 8.0, *) {
            (Calendar.current as NSCalendar).getHour(&hour, minute: &minute, second: &second, nanosecond: nil, from: date)
        } else {
            // Fallback on earlier versions
        }
        return (hour, minute, second)
    }
    //获取当前时间戳
    func getCurrentTimeStamp() -> String {
        let timeStamp : String = "\(Int64(floor(Date().timeIntervalSince1970 * 1000)))"
        return timeStamp
    }
    //获取当前年月日
    func getCurrentDate() -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.date(from: "yyyy-MM-dd")
        return formatter.string(from: Date())
    }
    //将时间转换为时间戳
    func change2TimeStamp(_ date : String) -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.date(from: "yyyy-MM-dd")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let dateNow = formatter.date(from: date)
        return "\(String(describing: dateNow?.timeIntervalSince1970))000"
    }
    ///将时间戳转化成时间
    func change2Date(_ timestamp : String) -> String {
        guard timestamp.utf8.count > 3 else {
            return ""
        }
        let newTimestamp = (timestamp as NSString).substring(from: timestamp.utf8.count - 3)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.date(from: "yyyy-MM-dd HH:mm:ss")
        
        let dateStart = Date(timeIntervalSince1970: Double(newTimestamp)!)
        return formatter.string(from: dateStart)
    }
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
            return self.getWeekString(fromInteger: weekIntValue)//周几
        }
    }
    //通过数字返回星期几
    func getWeekString(fromInteger week: Int) -> String {
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

