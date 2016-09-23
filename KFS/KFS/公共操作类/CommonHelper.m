//
//  CommonHelper.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/18.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

static CommonHelper* instance=nil;
+(CommonHelper *)shareHeper{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
  
    return instance;
}

-(NSString *)getWeekDay:(NSDate *)date{
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];

    
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

//时分秒hh:mm:ss
-(NSInteger)getMinitByTimeStr:(NSString *)str{
    if (str.length<8) {
        return 0;
    }
    NSInteger h=[[str substringWithRange:NSMakeRange(0, 2)]integerValue];
    NSInteger m=[[str substringWithRange:NSMakeRange(3, 2)]integerValue];
    NSInteger  s=[[str substringWithRange:NSMakeRange(6, 2)]integerValue];
    return h*60*60+m*60+s;
}
@end
