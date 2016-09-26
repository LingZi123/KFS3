//
//  ReducationTypeModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/26.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ReducationTypeModel.h"

@implementation ReducationTypeModel

#pragma mark-NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.modelId=[aDecoder decodeObjectForKey:@"modelId"];
        self.name=[aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_modelId forKey:@"modelId"];
    [aCoder encodeObject:_name forKey:@"name"];
}

+(ReducationTypeModel *)getModelWithDic:(NSDictionary *)dic{
    ReducationTypeModel *model=[[ReducationTypeModel alloc]init];
    model.modelId=[dic objectForKey:@"id"];
    model.name=[dic objectForKey:@"name"];
    return model;
}
@end
