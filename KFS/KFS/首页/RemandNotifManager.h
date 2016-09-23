//
//  RemandNotifManager.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/23.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemandModel.h"

@interface RemandNotifManager : NSObject

+(RemandNotifManager *)shareManager;

-(void)addLocalNotifWithModel:(RemandModel *)remandmodel;

-(void)deleteNotifWithModel:(RemandModel *)model;
@end
