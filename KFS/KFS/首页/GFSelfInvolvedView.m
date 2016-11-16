//
//  GFScoreView.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFSelfInvolvedView.h"

@implementation GFSelfInvolvedView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame: frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    UIImageView *locationImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 12.5, 19.5)];
    [locationImage setImage:[UIImage imageNamed:@"定位"]];
    [self addSubview:locationImage];
    locationImage.hidden=YES;
    
    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame)+10, 10, 200, 25)];
    locationLabel.font=DE_Font11;
    locationLabel.text=@"重庆市北部新区木星科技大厦";
    locationLabel.textColor=DE_BgColorPink;
    [self addSubview:locationLabel];
    locationLabel.hidden=YES;
    
    UILabel *headlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(locationLabel.frame)+8, 200, 21)];
    headlabel.font=DE_Font11;
    headlabel.text=@"我的自评";
    headlabel.textColor=DE_BgColorPink;
    [self addSubview:headlabel];
    
    soreBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-45, CGRectGetMaxY(headlabel.frame)+8, 90, 90)];
    [soreBtn setBackgroundImage:[UIImage imageNamed:@"低分"] forState:UIControlStateNormal];
    [soreBtn setTitle:@"0" forState:UIControlStateNormal];
    soreBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    soreBtn.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [soreBtn setTitleColor:DE_GreenColor forState:UIControlStateNormal];
    [soreBtn addTarget:self action:@selector(soreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:soreBtn];
    
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-70, CGRectGetMaxY(locationLabel.frame)+6, 60, 25)];
    [chakanBtn setTitle:@"马上自评 >" forState:UIControlStateNormal];
    [chakanBtn addTarget:self action:@selector(goMyValuation:) forControlEvents:UIControlEventTouchUpInside];
//    [chakanBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
    chakanBtn.titleLabel.font=DE_Font11;
    [chakanBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:chakanBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 0.5)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];

    
}

-(void)soreBtnClick:(UIButton *)sender{
    
    [self.delegate seeSoreTotal];
    
}
-(void)goMyValuation:(UIButton *)sender{
    [self.delegate anserQuestionClick];
}

-(void)refashScore:(NSString *)score{
    [soreBtn setTitle:score forState:UIControlStateNormal];
}
@end
