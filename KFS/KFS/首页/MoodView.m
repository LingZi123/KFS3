//
//  MoodView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MoodView.h"

@implementation MoodView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
        //获取位置
    UIImageView *locationImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 12.5, 19.5)];
    [locationImage setImage:[UIImage imageNamed:@"定位"]];
    [self addSubview:locationImage];
    
    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame)+10, 10, 200, 25)];
    locationLabel.font=DE_Font11;
    locationLabel.text=@"重庆市北部新区木星科技大厦";
    locationLabel.textColor=DE_BgColorPink;
    [self addSubview:locationLabel];
    
    xinqingview=[[MoodUnitView alloc]initWithFrame:CGRectMake(0, 0, 220, 26) count:5 subimagename:@""];
    xinqingview.titleLabel.text=@"心情：";
    xinqingview.center=CGPointMake(self.center.x, CGRectGetMaxY(locationLabel.frame)+32);
    [xinqingview.headImageView setImage:[UIImage imageNamed:@"心情2"]];
    [self addSubview:xinqingview];
    
    jiankangview=[[MoodUnitView alloc]initWithFrame:CGRectMake(0, 0,220, 26) count:5 subimagename:@""];
    [jiankangview.headImageView setImage:[UIImage imageNamed:@"健康2"]];
    jiankangview.titleLabel.text=@"健康：";
    jiankangview.center=CGPointMake(self.center.x, CGRectGetMaxY(xinqingview.frame)+24);
    [self addSubview:jiankangview];
    
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, CGRectGetMaxY(jiankangview.frame)+10, 60, 25)];
    [chakanBtn setTitle:@"查看评分" forState:UIControlStateNormal];
    [chakanBtn addTarget:self action:@selector(seeGrade:) forControlEvents:UIControlEventTouchUpInside];
    [chakanBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
    chakanBtn.titleLabel.font=DE_Font11;
     [chakanBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:chakanBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 1)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];

}

#pragma mark-动作事件

-(void)seeGrade:(UIButton *)sender{
    [self.delegate goGradePage];
}
-(void)jiankangBtnClick:(UIButton *)sender{
    
}
@end
