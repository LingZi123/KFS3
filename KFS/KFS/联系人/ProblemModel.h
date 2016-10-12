//
//  ProblemModel.h
//  KFS
//
//  Created by PC_201310113421 on 16/10/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemModel : NSObject

@property(nonatomic,retain)NSString *valueType;//问题值的类型
@property(nonatomic,retain)NSString *topic;//问题
@property(nonatomic,retain)NSString *problemId;
@property(nonatomic,retain)NSString *topicType;//问题类型
@property(nonatomic,retain)NSArray *problemValueArray;//问题的值
@property(nonatomic,retain)NSArray *prlblemClassifyArray;//
@property(nonatomic,retain)NSString *userId;//用户id；
@property(nonatomic,retain)NSString *value;//回答的答案；

+(ProblemModel *)getModelWithDic:(NSDictionary *)dic;
@end
