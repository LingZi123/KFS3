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
        _isOpen=[aDecoder decodeObjectForKey:@"isOpen"];
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
    [aCoder encodeObject:_isOpen forKey:@"isOpen"];
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

//1#2#3#4
-(NSString *)getRepeatDis:(NSString *)repeat{
    NSString *result=@"";
    if ([repeat isEqualToString:@"null"]) {
        return @"不重复";
    }
    if (repeat.length==13) {
        result=@"每天";
    }
    else if (repeat.length==3&&[repeat containsString:@"6"]&&[repeat containsString:@"7"]){
        result=@"周末";
    }
    else if (repeat.length==9&&[repeat containsString:@"1"]&&[repeat containsString:@"2"]
             &&[repeat containsString:@"3"]&&[repeat containsString:@"4"]
             &&[repeat containsString:@"5"]){
        result=@"工作日";
    }
    else{
        if ([repeat containsString:@"1"]) {
            result=[result stringByAppendingString:@"周一、"];
        }
        if ([repeat containsString:@"2"]){
            result=[result stringByAppendingString:@"周二、"];
        }
        if ([repeat containsString:@"3"]){
            result=[result stringByAppendingString:@"周三、"];
        }
        if ([repeat containsString:@"4"]){
            result=[result stringByAppendingString:@"周四、"];
        }
        if ([repeat containsString:@"5"]){
            result=[result stringByAppendingString:@"周五、"];
        }
        if ([repeat containsString:@"6"]){
            result=[result stringByAppendingString:@"周六、"];
        }
        if ([repeat containsString:@"7"]){
            result=[result stringByAppendingString:@"周日、"];
        }
        result=[result substringWithRange:NSMakeRange(0, result.length-1)];
    }
    return result;
}

-(NSMutableArray *)getRepeatArray:(NSString *)repeat{
    if ([repeat isEqualToString:@"null"]) {
        return nil;
    }
    else{
        NSMutableArray *array=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        if ([repeat containsString:@"1"]) {
           array[0]=@"1";
        }
        if ([repeat containsString:@"2"]){
           array[1]=@"1";        }
        if ([repeat containsString:@"3"]){
           array[2]=@"1";        }
        if ([repeat containsString:@"4"]){
           array[3]=@"1";
        }
        if ([repeat containsString:@"5"]){
           array[4]=@"1";
        }
        if ([repeat containsString:@"6"]){
            array[5]=@"1";
        }
        if ([repeat containsString:@"7"]){
            array[6]=@"1";
        }
        return array;
    }
}
@end
