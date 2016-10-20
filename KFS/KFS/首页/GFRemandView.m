//
//  GFRemandView.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFRemandView.h"
#import "RemandModel.h"

@implementation GFRemandView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self){
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
    
    view1=[[GFRemandUnitView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)/2-20)-120, CGRectGetMaxY(headlabel.frame)+20, 120, 70)];
    [view1.imageView setImage:[UIImage imageNamed:@"沙漏1"]];
    view1.mainLabel.text=@"无提醒";
    view1.subLabel.text=@"00:00";
    [self addSubview:view1];
    
    view2=[[GFRemandUnitView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame)+40, CGRectGetMaxY(headlabel.frame)+20, 120, 70)];
    [view2.imageView setImage:[UIImage imageNamed:@"闹铃1"]];
    view2.mainLabel.text=@"无提醒";
    view2.mainLabel.text=@"00:00";
    [self addSubview:view2];
    
    UIButton *settingBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-70, 8, 60, 25)];
    [settingBtn setTitle:@"去设置 >" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.titleLabel.font=DE_Font11;
//    [settingBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
    [settingBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:settingBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 0.5)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];

    
}

-(void)setBtnClick:(UIButton *)sender{
    [self.delegate goSetHelperPage];
}

-(void)fullLastMyRemandWithArray:(NSArray *)array{
    if (!array||array.count==0) {
        view1.mainLabel.text=@"无提醒";
        view1.subLabel.text=@"";
        view2.mainLabel.text=@"无提醒";
        view2.subLabel.text=@"";
    }
    else if(array.count==1){
        RemandModel *model=[array objectAtIndex:0];
        view1.mainLabel.text=model.name;
        view1.subLabel.text=[model.excuteTime substringWithRange:NSMakeRange(0, 5)];
        view2.mainLabel.text=@"无提醒";
        view2.subLabel.text=@"";
        
    }
    else{
        RemandModel *model1=[array objectAtIndex:0];
        RemandModel *model2=[array objectAtIndex:1];
        
        view1.mainLabel.text=model1.name;
        view1.subLabel.text=[model1.excuteTime substringWithRange:NSMakeRange(0, 5)];
        view2.mainLabel.text=model2.name;
        view2.subLabel.text=[model2.excuteTime substringWithRange:NSMakeRange(0, 5)];
    }
}


@end
