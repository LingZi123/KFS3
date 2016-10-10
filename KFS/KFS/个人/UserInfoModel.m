//
//  UserInfoModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_age forKey:@"age"];
    [aCoder encodeBool:_canLogin forKey:@"canLogin"];
    
    [aCoder encodeBool:_canSpeak forKey:@"canSpeak"];
    [aCoder encodeObject:_dontSpeakTime forKey:@"dontSpeakTime"];
    [aCoder encodeObject:_headImage forKey:@"headImage"];
    
    [aCoder encodeObject:_height forKey:@"height"];
    [aCoder encodeInteger:_userId forKey:@"userId"];
    [aCoder encodeBool:_isCheck forKey:@"isCheck"];
    
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_trueName forKey:@"trueName"];
    
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_weight forKey:@"weight"];
     [aCoder encodeObject:_pwd forKey:@"pwd"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.address=[aDecoder decodeObjectForKey:@"address"];
        self.age=[aDecoder decodeObjectForKey:@"age"];
        self.canLogin=[aDecoder decodeBoolForKey:@"canLogin"];
        self.canSpeak=[aDecoder decodeBoolForKey:@"canSpeak"];
        self.dontSpeakTime=[aDecoder decodeObjectForKey:@"dontSpeakTime"];
        self.headImage=[aDecoder decodeObjectForKey:@"headImage"];
        self.height=[aDecoder decodeObjectForKey:@"height"];
        self.userId=[aDecoder decodeIntegerForKey:@"userId"];
        self.isCheck=[aDecoder decodeBoolForKey:@"isCheck"];
        self.phone=[aDecoder decodeObjectForKey:@"phone"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.trueName=[aDecoder decodeObjectForKey:@"trueName"];
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.weight=[aDecoder decodeObjectForKey:@"weight"];
        self.pwd=[aDecoder decodeObjectForKey:@"pwd"];

    }
    return self;
}

+(UserInfoModel *)getModelWithDic:(NSDictionary *)dic{
    UserInfoModel *model=[[UserInfoModel alloc]init];
    model.address=[dic objectForKey:@"address"];
    model.age=[dic objectForKey:@"age"];
    id canloginid=[dic objectForKey:@"canLogin"];
    if (canloginid && canloginid!=(id)[NSNull null]) {
        model.canLogin=[[dic objectForKey:@"canLogin"] boolValue];
    }
    else{
        model.canLogin=YES;
    }
    
    id canspeakid=[dic objectForKey:@"canSpeak"];
    if (canspeakid &&canspeakid!=(id)[NSNull null]) {
        model.canSpeak=[[dic objectForKey:@"canSpeak"] boolValue];
    }
    else{
        model.canSpeak=YES;
    }
    model.dontSpeakTime=[dic objectForKey:@"dontSpeakTime"];
    model.headImage=[dic objectForKey:@"headImage"];
    model.height=[dic objectForKey:@"height"];
    model.userId=[[dic objectForKey:@"userId"] integerValue];
    
    id ischeckid=[dic objectForKey:@"isCheck"];
    if (ischeckid && ischeckid!=(id)[NSNull null]) {
        model.isCheck=[[dic objectForKey:@"isCheck"] boolValue];
    }
    
    model.phone=[dic objectForKey:@"phone"];
    model.sex=[dic objectForKey:@"sex"];
    model.trueName=[dic objectForKey:@"trueName"];
    model.username=[dic objectForKey:@"username"];
    model.weight=[dic objectForKey:@"weight"];

    return model;
}
@end
