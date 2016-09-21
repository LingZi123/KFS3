//
//  MoodAndHealthModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/21.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoodAndHealthModel : NSObject<NSCoding>

@property(nonatomic,retain)NSString *username;//用户名
@property(nonatomic,retain)NSString *mydate;//日期 yyyy-MM-dd
@property(nonatomic,retain)NSString *healthStarIndex;//健康
@property(nonatomic,retain)NSString *moodStarIndex;//心情
@property(nonatomic,assign)BOOL isPost;//是否提交

//+(MoodAndHealthModel *)getModelWidthDate:(nsda)

@end
