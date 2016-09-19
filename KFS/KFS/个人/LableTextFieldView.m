//
//  LableTextFieldView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/17.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LableTextFieldView.h"

@implementation LableTextFieldView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame: frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-21)/2, 50, 21)];
     _titleLabel.font=DE_Font14;
    _titleLabel.textColor=DE_BgColorPink;
    [self addSubview:_titleLabel];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+6,(CGRectGetHeight(self.frame)-30)/2, self.frame.size.width-58, 30)];
    _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.font=DE_Font14;
    [self addSubview:_textField];
}
@end
