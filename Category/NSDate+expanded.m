

#import "NSDate+expanded.h"
#define D_MINUTE  60
#define D_HOUR    3600
#define D_DAY    86400
#define D_WEEK    604800
#define D_YEAR    31556926
#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
@implementation NSDate (expanded)
/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}
//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    if (weekday > 1) {
        weeks += 1;
        days -= (7 - weekday + 1);
    }
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    return weeks;
}
/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}
//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}
- (NSDate *)lastDayOfCurrentMonth{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}
//上一个月
- (NSDate *)dayInThePreviousMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}
//下一个月
- (NSDate *)dayInTheFollowingMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}
//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}
//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}
//获取当前日期之前的几个天
- (NSDate *)dayBeforeTheFollowingDay:(int)day{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}
//获取年月日对象
- (NSDateComponents *)YMDComponents{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:self];
}
//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//日历控件对象
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return (int)day;
}
//周日是“1”，周一是“2”...
-(int)getWeekIntValueWithDate{
    int weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = (int)[comps weekday];
}
//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:todate];
    NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:self];
    //获取星期对应的数字
    int weekIntValue = [self getWeekIntValueWithDate];
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else{
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
}

//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week{
    NSString *str_week;
    switch (week) {
        case 1:str_week = @"周日";break;
        case 2:str_week = @"周一";break;
        case 3:str_week = @"周二";break;
        case 4:str_week = @"周三";break;
        case 5:str_week = @"周四";break;
        case 6:str_week = @"周五";break;
        case 7:str_week = @"周六";break;
    }
    return str_week;
}
//FIXME:以下是微信的扩展
#pragma mark Decomposing Dates
- (NSUInteger) nearestHour{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}
- (NSUInteger) week{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}
- (NSUInteger)day {
    return [NSDate day:self];
}
- (NSUInteger)month {
    return [NSDate month:self];
}
- (NSUInteger)year {
    return [NSDate year:self];
}
- (NSUInteger)hour {
    return [NSDate hour:self];
}
- (NSUInteger)minute {
    return [NSDate minute:self];
}
- (NSUInteger)second {
    return [NSDate second:self];
}
+ (NSUInteger)day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
#endif
    return [dayComponents day];
}
+ (NSUInteger)month:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
#endif
    return [dayComponents month];
}
+ (NSUInteger)year:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
#endif
    return [dayComponents year];
}
+ (NSUInteger)hour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:date];
#endif
    return [dayComponents hour];
}
+ (NSUInteger)minute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:date];
#endif
    return [dayComponents minute];
}
+ (NSUInteger)second:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:date];
#endif
    return [dayComponents second];
}
- (BOOL)isLeapYear {
    return [NSDate isLeapYear:self];
}
+ (BOOL)isLeapYear:(NSDate *)date {
    NSUInteger year = [date year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}
- (NSString *)formatYMD {
    return [NSString stringWithFormat:@"%lu年%02lu月%02lu日", (unsigned long)[self year],(unsigned long)[self month], (unsigned long)[self day]];
}
- (NSString *)formatYMDWith:(NSString *)c{
    return [NSString stringWithFormat:@"%lu%@%02lu%@%02lu", (unsigned long)[self year], c, (unsigned long)[self month], c, (unsigned long)[self day]];
}
- (NSString *)formatHM {
    return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)[self hour], (unsigned long)[self minute]];
}
- (NSInteger)weekday {
    return [NSDate weekday:self];
}
+ (NSInteger)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    return weekday;
}
- (NSString *)dayFromWeekday {
    return [NSDate dayFromWeekday:self];
}
+ (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:return @"星期天";break;
        case 2:return @"星期一";break;
        case 3:return @"星期二";break;
        case 4:return @"星期三";break;
        case 5:return @"星期四";break;
        case 6:return @"星期五";break;
        case 7:return @"星期六";break;
        default:break;
    }
    return @"";
}
/**
 *  Get the month as a localized string from the given month number
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *  @return Return the given month as a localized string
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:return @"January";break;
        case 2:return @"February";break;
        case 3:return @"March";break;
        case 4:return @"April";break;
        case 5:return @"May";break;
        case 6:return @"June";break;
        case 7:return @"July";break;
        case 8:return @"August";break;
        case 9:return @"September";break;
        case 10:return @"October";break;
        case 11:return @"November";break;
        case 12:return @"December";break;
        default:break;
    }
    return @"";
}
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date stringWithFormat:format];
}
- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *retStr = [outputFormatter stringFromDate:self];
    return retStr;
}
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}
- (NSUInteger)daysInMonth:(NSUInteger)month {
    return [NSDate daysInMonth:self month:month];
}
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date isLeapYear] ? 29 : 28;
    }
    return 30;
}
- (NSUInteger)daysInMonth {
    return [NSDate daysInMonth:self];
}
+ (NSUInteger)daysInMonth:(NSDate *)date {
    return [self daysInMonth:date month:[date month]];
}
- (NSString *)timeInfo {
    return [NSDate timeInfoWithDate:self];
}
+ (NSString *)timeInfoWithDate:(NSDate *)date {
    return [self timeInfoWithDateString:[self stringWithDate:date format:@"yyyy-MM-dd HH:mm:ss"]];
}
+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    NSDate *date = [self dateWithString:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    int month = (int)([curDate month] - [date month]);
    int year = (int)([curDate year] - [date year]);
    int day = (int)([curDate day] - [date day]);
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate month] == 1 && [date month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self daysInMonth:date month:[date month]];
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate day] + (totalDays - (int)[date day]);
        }
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            // 隔年
            int month = (int)[curDate month];
            int preMonth = (int)[date month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    return @"1小时前";
}
//FIXME:以下是微信的工具类扩展
+ (NSCalendar *) currentCalendar{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}
#pragma mark Relative Dates
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}
+ (NSDate *) dateTomorrow{
    return [NSDate dateWithDaysFromNow:1];
}
+ (NSDate *) dateYesterday{
    return [NSDate dateWithDaysBeforeNow:1];
}
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
#pragma mark - String Properties
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}
- (NSString *) shortString{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}
- (NSString *) shortTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}
- (NSString *) shortDateString{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}
- (NSString *) mediumString{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}
- (NSString *) mediumTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}
- (NSString *) mediumDateString{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}
- (NSString *) longString{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}
- (NSString *) longTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}
- (NSString *) longDateString{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}
#pragma mark Comparing Dates
- (BOOL) isSameDay: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (BOOL) isToday{
    return [self isSameDay:[NSDate date]];
}
- (BOOL) isTomorrow{
    return [self isSameDay:[NSDate dateTomorrow]];
}
/**
 *  判断某个时间是否为昨天
 */
- (BOOL) isYesterday{
    return [self isSameDay:[NSDate dateYesterday]];
}
// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate];
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}
- (BOOL) isThisWeek{
    return [self isSameWeekAsDate:[NSDate date]];
}
- (BOOL) isNextWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
- (BOOL) isLastWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}
- (BOOL) isThisMonth{
    return [self isSameMonthAsDate:[NSDate date]];
}
- (BOOL) isLastMonth{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}
- (BOOL) isNextMonth{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}
- (BOOL) isSameYearAsDate: (NSDate *) aDate{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}
- (BOOL) isThisYear{
    return [self isSameYearAsDate:[NSDate date]];
}
- (BOOL) isNextYear{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}
- (BOOL) isLastYear{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}
- (BOOL) isEarlierThanDate: (NSDate *) aDate{
    return ([self compare:aDate] == NSOrderedAscending);
}
- (BOOL) isLaterThanDate: (NSDate *) aDate{
    return ([self compare:aDate] == NSOrderedDescending);
}
// Thanks, markrickert
- (BOOL) isInFuture{
    return ([self isLaterThanDate:[NSDate date]]);
}
// Thanks, markrickert
- (BOOL) isInPast{
    return ([self isEarlierThanDate:[NSDate date]]);
}
#pragma mark Roles
- (BOOL) isTypicallyWeekend{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}
- (BOOL) isTypicallyWorkday{
    return ![self isTypicallyWeekend];
}
#pragma mark Adjusting Dates
// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears{
    return [self dateByAddingYears:-dYears];
}
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths{
    return [self dateByAddingMonths:-dMonths];
}
// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays{
    return [self dateByAddingDays: (dDays * -1)];
}
- (NSDate *) dateByAddingHours: (NSInteger) dHours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours{
    return [self dateByAddingHours: (dHours * -1)];
}
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}
- (NSDate *) dateAtStartOfDay{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
// Thanks gsempe & mteece
- (NSDate *) dateAtEndOfDay{
    NSDateComponents *components = [[NSDate currentCalendar] components:DATE_COMPONENTS fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}
- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate{
    NSDateComponents *dTime = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}
#pragma mark Retrieving Intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}
- (NSInteger) minutesBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}
- (NSInteger) hoursAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}
- (NSInteger) hoursBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}
- (NSInteger) daysAfterDate: (NSDate *) aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}
- (NSInteger) daysBeforeDate: (NSDate *) aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}
// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}
- (NSString *)chatTimeInfo{
    if ([self isToday]) {       // 今天
        return self.formatHM;
    }else if ([self isYesterday]) {      // 昨天
        return [NSString stringWithFormat:@"昨天 %@", self.formatHM];
    }else if ([self isThisWeek]){        // 本周
        return [NSString stringWithFormat:@"%@ %@", self.dayFromWeekday, self.formatHM];
    }else {
        return [NSString stringWithFormat:@"%@ %@", self.formatYMD, self.formatHM];
    }
}
- (NSString *)conversaionTimeInfo{
    if ([self isToday]) {       // 今天
        return self.formatHM;
    }else if ([self isYesterday]) {      // 昨天
        return @"昨天";
    }else if ([self isThisWeek]){        // 本周
        return self.dayFromWeekday;
    }else {
        return [self formatYMDWith:@"/"];
    }
}
- (NSString *)chatFileTimeInfo{
    if ([self isThisWeek]) {
        return @"本周";
    }else if ([self isThisMonth]) {
        return @"这个月";
    }else {
        return [NSString stringWithFormat:@"%ld年%ld月", (long)self.year, (long)self.month];
    }
}
@end
