//
//  GFDoctorSuggest.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFDoctorSuggest.h"

@implementation GFDoctorSuggest

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    UILabel *headlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 8, 200, 21)];
    headlabel.font=DE_Font11;
    headlabel.text=@"医生建议";
    headlabel.textColor=DE_BgColorPink;
    [self addSubview:headlabel];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(headlabel.frame)+10, CGRectGetWidth(self.frame)-16, 80)];
    imageview.image=[UIImage imageNamed:@"专家"];
    [self addSubview:imageview];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, CGRectGetMaxY(headlabel.frame)+18, CGRectGetWidth(imageview.frame)-120, 64)];
    _titleLabel.font=DE_Font14;
    _titleLabel.numberOfLines=0;
    _titleLabel.text=@"暂无建议";
    [self addSubview:_titleLabel];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:imageview.frame];
    [self addSubview:btn];
    

    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 0.5)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];
}

@end
