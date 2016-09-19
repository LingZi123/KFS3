//
//  RemandUnitView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemandUnitView.h"

@implementation RemandUnitView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self makeView];
    }
    return self;
}

-(void)makeView{

    _imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:_imageview];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,12 , 50, 15)];
    _titleLabel.font=DE_Font11;
    _titleLabel.textColor=[UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    UIView *seg=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+5, 70, 0.5)];
    seg.backgroundColor=[UIColor whiteColor];
    [self addSubview:seg];
    
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(seg.frame)+3, 50, 15)];
    _timeLabel.font=DE_Font11;
    _timeLabel.textColor=[UIColor whiteColor];
    [self addSubview:_timeLabel];
    
}
@end
