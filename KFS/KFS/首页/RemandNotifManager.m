//
//  RemandNotifManager.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/23.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemandNotifManager.h"
#import "RemandModel.h"
#import "CommonHelper.h"
#import <UIKit/UIKit.h>

@implementation RemandNotifManager

static RemandNotifManager *instance=nil;

+(RemandNotifManager *)shareManager{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

-(void)addLocalNotifWithModel:(RemandModel *)remandmodel  {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *inputDateStr=[NSString stringWithFormat:@"%@ %@",remandmodel.beginDate,remandmodel.excuteTime];
    NSDate* inputDate = [inputFormatter dateFromString:inputDateStr];
    
    NSInteger weekDay=[[[CommonHelper shareHeper] getWeekDay:inputDate] integerValue];
    NSLog(@"%@",inputDate);
    
    if ([remandmodel.isRepeat isEqualToString:@"null"]) {
        
        UILocalNotification *notification=[self getNewNotif];
        notification.alertBody=remandmodel.name;//提示信息 弹出提示框
        notification.fireDate=inputDate;
        notification.repeatInterval=0;
        NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@一次",inputDateStr] forKey:[NSString stringWithFormat:@"%ld#%@",(long)remandmodel.modelId, remandmodel.name]];
        notification.userInfo = infoDict; //添加额外的信息
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else{
        // 添加通知
        if ([remandmodel.isRepeat isEqualToString:DE_Everyday]) {
            UILocalNotification *notification=[self getNewNotif];
            notification.alertBody=remandmodel.name;//提示信息 弹出提示框
            
            notification.fireDate=inputDate;
            notification.repeatInterval=NSCalendarUnitDay;//循环次数，kCFCalendarUnitWeekday一天一次
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@每天",inputDateStr] forKey:[NSString stringWithFormat:@"%ld#%@",(long)remandmodel.modelId, remandmodel.name]];
            notification.userInfo = infoDict; //添加额外的信息
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else if ([remandmodel.isRepeat isEqualToString:DE_JobDay]){
            
            for (int i=1; i<6; i++) {
                UILocalNotification *notification=[self getNewNotif];
                notification.alertBody=remandmodel.name;//提示信息 弹出提示框
                
                NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:[NSString stringWithFormat:@"%ld#%@",(long)remandmodel.modelId, remandmodel.name]];
                
                [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
            }
        }
        else if ([remandmodel.isRepeat isEqualToString:DE_WeekendDay]){
            
            for (int i=6; i<8; i++) {
                UILocalNotification *notification=[self getNewNotif];
                notification.alertBody=remandmodel.name;//提示信息 弹出提示框
                NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:[NSString stringWithFormat:@"%ld#%@",(long)remandmodel.modelId, remandmodel.name]];
                
                [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
            }
        }
        else{
            
            NSMutableArray *repeatArray=[remandmodel getRepeatArray:remandmodel.isRepeat];
            for (int i=1; i<8; i++) {
                
                NSString *item =repeatArray[i-1];
                if ([item isEqualToString:@"0"]) {
                    continue;
                }
                
                UILocalNotification *notification=[self getNewNotif];
                notification.alertBody=remandmodel.name;//提示信息 弹出提示框
                
                NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:[NSString stringWithFormat:@"%ld#%@",(long)remandmodel.modelId, remandmodel.name]];
                [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
            }
            
        }
    }
    
}

-(void)exeAddNotifWeekDay:(NSInteger )weekday  curentWeekDay:(NSInteger )currentWeekDay notification:(UILocalNotification *)notification inputDate:(NSDate *)inputDate info:(NSDictionary *)info{
    
    NSInteger a=weekday-currentWeekDay;
    if (a<0) {
        a+=7;
    }
    notification.fireDate=[inputDate dateByAddingTimeInterval:a*60*60*24];
    notification.repeatInterval=NSCalendarUnitWeekday;//循环次数，kCFCalendarUnitWeekday一周一次
    notification.userInfo=info;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)deleteNotifWithModel:(RemandModel *)model{
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    for (UILocalNotification *itme in localNotifications) {
        NSDictionary *dicInfo=itme.userInfo;
        
        if ([dicInfo.allKeys containsObject:[NSString stringWithFormat:@"%lD#%@",(long)model.modelId,model.name]]) {
            [[UIApplication sharedApplication]cancelLocalNotification:itme];
            
        }
    }
}

-(UILocalNotification *)getNewNotif{
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"短信08" ofType:@"caf"];
    NSLog(@"path-------------%@",path);
    notification.soundName=@"故事03.m4a";
    notification.applicationIconBadgeNumber++;//应用的红色数字
    
    //去掉下面2行就不会弹出提示框
    notification.alertTitle=@"任务通知";
    notification.alertAction = @"打开";  //提示框按钮
    notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
    return notification;
}
@end
