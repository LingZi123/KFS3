//
//  UserInfoModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/10/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject<NSCoding>

@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)NSString *age;
@property(nonatomic,assign)BOOL canLogin;
@property(nonatomic,assign)BOOL canSpeak;
@property(nonatomic,retain)NSString *dontSpeakTime;
@property(nonatomic,retain)NSString *headImage;
@property(nonatomic,retain)NSString *height;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)BOOL isCheck;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *sex;
@property(nonatomic,retain)NSString *trueName;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *weight;

@property(nonatomic,retain)NSString *pwd;

+(UserInfoModel *)getModelWithDic:(NSDictionary *)dic;
@end
