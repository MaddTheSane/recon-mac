//
//  NSCalendarDate-NTExtensions.h
//  CocoatechCore
//
//  Created by Steve Gehrman on 7/23/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NS_CALENDAR_DEPRECATED(10_4, 10_10, 2_0, 8_0, "Use NSCalendar and NSDateComponents and NSDateFormatter instead")
@interface NSCalendarDate (NTExtensions)

+ (NSCalendarDate*)today; // begining of day

// begining of day (like today)
+ (NSCalendarDate*)dayWithDate:(NSDate*)date;

+ (NSCalendarDate*)todayAndDays:(int)days;
+ (NSCalendarDate*)week;
+ (NSCalendarDate*)weekAndWeeks:(int)weeks;
+ (NSCalendarDate*)month;
+ (NSCalendarDate*)monthAndMonths:(int)months;
+ (NSCalendarDate*)year;
+ (NSCalendarDate*)yearAndYears:(int)years;

@end
