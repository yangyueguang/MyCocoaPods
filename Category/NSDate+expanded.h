
#import <Foundation/Foundation.h>
@interface NSDate (expanded)
- (NSUInteger)numberOfDaysInCurrentMonth;
- (NSUInteger)numberOfWeeksInCurrentMonth;
- (NSUInteger)weeklyOrdinality;
- (NSDate *)firstDayOfCurrentMonth;
- (NSDate *)lastDayOfCurrentMonth;
- (NSDate *)dayInThePreviousMonth;
- (NSDate *)dayInTheFollowingMonth;
- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天
//获取当前日期之前的几个天
- (NSDate *)dayBeforeTheFollowingDay:(int)day;
- (NSDateComponents *)YMDComponents;
- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate
- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString
+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;
-(int)getWeekIntValueWithDate;
//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;
@property (readonly) NSUInteger nearestHour;
@property (readonly) NSUInteger hour;
@property (readonly) NSUInteger minute;
@property (readonly) NSUInteger second;
@property (readonly) NSUInteger day;
@property (readonly) NSUInteger month;
@property (readonly) NSUInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSUInteger year;
- (BOOL)isYesterday;
- (BOOL)isToday;
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
+ (NSUInteger)day:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)hour:(NSDate *)date;
+ (NSUInteger)minute:(NSDate *)date;
+ (NSUInteger)second:(NSDate *)date;
- (NSString *)formatYMD;
- (NSString *)formatYMDWith:(NSString *)c;
- (NSString *)formatHM;
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;
+ (NSString *)monthWithMonthNumber:(NSInteger)month;
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;
//获取当前月份的天数
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;
//返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(NSDate *)date;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;
+ (NSCalendar *) currentCalendar; // avoid bottlenecks
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
-(NSString *)timeToNow;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;
// Comparing dates
- (BOOL) isSameDay: (NSDate *) aDate;
- (BOOL) isTomorrow;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isNextMonth;
- (BOOL) isLastMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;
// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;
// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
// Date extremes
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtEndOfDay;
// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) distanceInDaysToDate:(NSDate *)anotherDate;
- (NSString *)chatTimeInfo;
- (NSString *)conversaionTimeInfo;
- (NSString *)chatFileTimeInfo;
@end
