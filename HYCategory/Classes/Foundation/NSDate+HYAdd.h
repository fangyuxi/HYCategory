//
//  NSDate+HYAdd.h
//  Pods
//
//  Created by fangyuxi on 2017/1/12.
//
//

#import <Foundation/Foundation.h>

/**
 关于时间的处理，可以看这篇文章 转 : https://zhuanlan.zhihu.com/p/24377367?refer=mrpeak
 */

@interface NSDate(HYAdd)

#pragma mark - 日历快捷方法

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger quarter;
@property (nonatomic, readonly) BOOL isLeapMonth;
@property (nonatomic, readonly) BOOL isLeapYear;
@property (nonatomic, readonly) BOOL isToday;
@property (nonatomic, readonly) BOOL isYesterday;


#pragma mark - 更改日期

- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

#pragma mark - 日期格式化

//create NSDateFormatter is not cheap，you could reuse a NSDateFormatter instance
//before iOS6 NSDateFormatter is not thread-safety,so you could notice that when NSDateFormatter
//is a static instance

//from apple

//Creating a date formatter is not a cheap operation. If you are likely to use a formatter frequently, it is typically more efficient to cache a single instance than to create and dispose of multiple instances. One approach is to use a static variable

- (NSString *)stringWithFormat:(NSString *)format
                      timeZone:(NSTimeZone *)timeZone
                        locale:(NSLocale *)locale
                     formatter:(NSDateFormatter *)formatter;

+ (NSDate *)dateWithString:(NSString *)dateString
                    format:(NSString *)format
                 formatter:(NSDateFormatter *)formatter;

+ (NSDate *)dateWithString:(NSString *)dateString
                    format:(NSString *)format
                  timeZone:(NSTimeZone *)timeZone
                    locale:(NSLocale *)locale
                 formatter:(NSDateFormatter *)formatter;
@end
