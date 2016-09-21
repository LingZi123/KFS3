//
//  MoodUnitView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MoodUnitView.h"

@implementation MoodUnitView

-(instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count subimagename:(NSString *)subimagename{
    self=[super initWithFrame:frame];
    if (self) {
        _btnCount=count;
        _subImageName=subimagename;
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 26)];
    [self addSubview:_headImageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame)+8, 2.5, 35, 21)];
    _titleLabel.font=DE_Font11;
    _titleLabel.textColor=DE_BgColorPink;
    [self addSubview:_titleLabel];
    
    for (int i=0; i<_btnCount; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+8+i*(20+8), 3, 20, 19.2)];
        btn.tag=100+i;
        [btn setImage:[UIImage imageNamed:@"星星2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"星星填充2"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}


//填充
-(void)fullStart:(NSInteger)StartIndex  seleted:(BOOL)selected{
    NSInteger count=StartIndex;
    BOOL myselected=selected;
    
    if (StartIndex==0) {
        count=5;
        myselected=NO;
        _selected=NO;
    }
    for (int i=0; i<StartIndex; i++) {
        _selected=YES;
        UIButton *btn=(UIButton *)[self viewWithTag:100+i];
        btn.selected=myselected;
    }
}

-(void)btnClick:(UIButton *)sender{
     //有一个选了就不能选已经选择不能修改
    if (self.selected) {
        return;
    }
    if (sender.selected) {
        return;
    }
    NSInteger i=sender.tag-100;
    sender.selected=YES;
    _selected=YES;
    for(int j=0;j<i;j++)
    {
        UIButton *btn=(UIButton *)[self viewWithTag:100+j];
        btn.selected=YES;
    }
    [self.delegate moodUnitViewDidBtnSelected:self star:[NSString stringWithFormat:@"%lD",(long)i]];
}

@end
