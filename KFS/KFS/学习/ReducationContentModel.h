//
//  ReducationContentModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReducationContentModel : NSObject

@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *contentSource;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *modelId;
@property(nonatomic,retain)NSString *userId;

+(ReducationContentModel *)getModelWithDic:(NSDictionary *)dic;
@end
