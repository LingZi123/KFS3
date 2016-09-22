//
//  RemandModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/21.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemandModel : NSObject<NSCoding>

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *beginDate;
@property(nonatomic,retain)NSString *excuteTime;//执行日期
@property(nonatomic,retain)NSString *isRepeat;//重复字符串用＃拼凑 例如周一、周二、 1＃2 没有用“null”
@property(nonatomic,assign)BOOL isOpen;//是否打开
@property(nonatomic,assign)NSInteger modelId;//
+(RemandModel *)getModelWithDic:(NSDictionary *)dic;

@end
