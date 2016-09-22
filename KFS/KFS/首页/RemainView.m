//
//  RemainView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemainView.h"
#import "RemandModel.h"

@implementation RemainView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    UILabel *headlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 21)];
    headlabel.font=DE_Font11;
    headlabel.text=@"我的提醒";
    headlabel.textColor=DE_BgColorPink;
    [self addSubview:headlabel];
    
    view1=[[RemandUnitView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-270)/2, CGRectGetMaxY(headlabel.frame)+20, 115, 68)];
    [view1.imageview setImage:[UIImage imageNamed:@"沙漏"]];
    view1.titleLabel.text=@"无提醒";
    view1.timeLabel.text=@"00:00";
    [self addSubview:view1];
    
    view2=[[RemandUnitView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame)+40, CGRectGetMaxY(headlabel.frame)+20, 115, 68)];
    [view2.imageview setImage:[UIImage imageNamed:@"闹铃"]];
    view2.titleLabel.text=@"无提醒";
    view2.timeLabel.text=@"00:00";
    [self addSubview:view2];

    UIButton *settingBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, CGRectGetMaxY(view2.frame)+12, 60, 25)];
    [settingBtn setTitle:@"助手设置" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.titleLabel.font=DE_Font11;
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
     [settingBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:settingBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 1)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];
}

-(void)setBtnClick:(UIButton *)sender{
    [self.delegate goSetHelperPage];
}

-(void)fullLastMyRemandWithArray:(NSArray *)array{
    if (!array||array.count==0) {
        view1.titleLabel.text=@"无提醒";
        view1.timeLabel.text=@"00:00";
        view2.titleLabel.text=@"无提醒";
        view2.timeLabel.text=@"00:00";
    }
    else if(array.count==1){
        RemandModel *model=[array objectAtIndex:0];
        view1.titleLabel.text=model.name;
        view1.timeLabel.text=[model.excuteTime substringWithRange:NSMakeRange(0, 5)];
        view2.titleLabel.text=@"无提醒";
        view2.timeLabel.text=@"00:00";

    }
    else{
        RemandModel *model1=[array objectAtIndex:0];
        RemandModel *model2=[array objectAtIndex:1];
        
        view1.titleLabel.text=model1.name;
        view1.timeLabel.text=[model1.excuteTime substringWithRange:NSMakeRange(0, 5)];
        view2.titleLabel.text=model2.name;
        view2.timeLabel.text=[model2.excuteTime substringWithRange:NSMakeRange(0, 5)];
    }
}


@end
