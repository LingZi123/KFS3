//
//  ProblemModel.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ProblemModel.h"

@implementation ProblemModel
+(ProblemModel *)getModelWithDic:(NSDictionary *)dic{
    ProblemModel *model=[[ProblemModel alloc]init];
    model.topic=[dic objectForKey:@"topic"];
    model.problemId= [dic objectForKey:@"id"];
    model.topicType=[dic objectForKey:@"topic_type"];
    model.problemValueArray=[dic objectForKey:@"problem_value"];
    model.prlblemClassifyArray=[dic objectForKey:@"problem_classify"];
    model.userId=[dic objectForKey:@"user_id"];
    model.valueType=[dic objectForKey:@"value_type"];
    return  model;
}
@end
