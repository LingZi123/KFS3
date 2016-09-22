//
//  RemandModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/21.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemandModel.h"

@implementation RemandModel

#pragma mark-NSCoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        _name=[aDecoder decodeObjectForKey:@"name"];
        _beginDate=[aDecoder decodeObjectForKey:@"beginDate"];
        _excuteTime=[aDecoder decodeObjectForKey:@"excuteTime"];
        _isOpen=[aDecoder decodeBoolForKey:@"isOpen"];
        _isRepeat=[aDecoder decodeObjectForKey:@"isRepeat"];
        _modelId=[aDecoder decodeIntegerForKey:@"modelId"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_beginDate forKey:@"beginDate"];
    [aCoder encodeObject:_excuteTime forKey:@"excuteTime"];
    [aCoder encodeObject:_isRepeat forKey:@"isRepeat"];
    [aCoder encodeBool:_isOpen forKey:@"isOpen"];
     [aCoder encodeInteger:_modelId forKey:@"modelId"];
}

+(RemandModel *)getModelWithDic:(NSDictionary *)dic{
    RemandModel *model=[[RemandModel alloc]init];
    
    model.name=[dic objectForKey:@"name"];
    model.modelId=[[dic objectForKey:@"id"]integerValue];
    model.isOpen=[dic objectForKey:@"is_open"];
    model.isRepeat=[dic objectForKey:@"is_repeat"];
    
    NSString *str1=[dic objectForKey:@"execution_time"];
    model.beginDate=[str1 substringWithRange:NSMakeRange(0, 10)];
    model.excuteTime=[str1 substringFromIndex:11];
    
    return model;

}
@end
