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
    model.hashKey=[dic objectForKey:@"$$hashKey"];
    model.created_at=[dic objectForKey:@"created_at"];
    model.updated_at=[dic objectForKey:@"updated_at"];

    return  model;
}

-(NSDictionary *)getDicWithModel:(ProblemModel *)model{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:model.topic forKey:@"topic"];
     [dic setObject:model.problemId forKey:@"id"];
     [dic setObject:model.topicType forKey:@"topic_type"];
     [dic setObject:model.problemValueArray forKey:@"problem_value"];
     [dic setObject:model.prlblemClassifyArray forKey:@"problem_classify"];
     [dic setObject:model.userId forKey:@"user_id"];
     [dic setObject:model.valueType forKey:@"value_type"];
     [dic setObject:model.hashKey forKey:@"$$hashKey"];
     [dic setObject:model.created_at forKey:@"created_at"];
     [dic setObject:model.updated_at forKey:@"updated_at"];
    if (model.value==nil) {
        model.value=@"";
    }
     [dic setObject:model.value forKey:@"value"];
    
    return  dic;
}

-(NSDictionary *)getValueDicWithModel:(ProblemModel *)model{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:model.problemId forKey:@"problem_id"];
    if (model.value==nil) {
        model.value=@"";
    }
    [dic setObject:model.value forKey:@"value"];
    
    return  dic;
}
@end
