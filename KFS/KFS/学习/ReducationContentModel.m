//
//  ReducationContentModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ReducationContentModel.h"

@implementation ReducationContentModel
+(ReducationContentModel *)getModelWithDic:(NSDictionary *)dic{
    ReducationContentModel *model=[[ReducationContentModel alloc]init];
    model.content=[dic objectForKey:@"content"];
    model.contentSource=[dic objectForKey:@"content_source"];
    model.modelId=[dic objectForKey:@"id"];
    model.pic =[dic objectForKey:@"pic"];
    model.title=[dic objectForKey:@"title"];
    model.type=[dic objectForKey:@"type"];
    model.userId=[dic objectForKey:@"user_id"];
    
    return model;
}
@end
