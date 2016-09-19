//
//  CommonHelper.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/18.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

static CommonHelper* instance=nil;
+(CommonHelper *)shareHeper{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
  
    return instance;
}


@end
