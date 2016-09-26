//
//  ReducationTypeModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReducationTypeModel : NSObject<NSCoding>

@property(nonatomic,retain)NSString *modelId;
@property(nonatomic,retain)NSString *name;

+(ReducationTypeModel *)getModelWithDic:(NSDictionary *)dic;
@end
