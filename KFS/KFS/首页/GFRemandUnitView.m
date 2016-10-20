//
//  GFRemandUnitView.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFRemandUnitView.h"

@implementation GFRemandUnitView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 45, 45)];
    
    [self addSubview:_imageView];
    
    _mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+2, 10, CGRectGetWidth(self.frame)-CGRectGetMaxX(_imageView.frame), 21)];
    _mainLabel.font=[UIFont systemFontOfSize:13];
    _mainLabel.textColor=[UIColor colorWithRed:0x1c/255.0 green:0x1c/255.0 blue:0x1c/255.0 alpha:1.0];
    
    [self addSubview:_mainLabel];
    
    _subLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+8, CGRectGetMaxY(_mainLabel.frame)+6, _mainLabel.frame.size.width, _mainLabel.frame.size.height)];
    _subLabel.font=[UIFont systemFontOfSize:13];
    _subLabel.textColor=[UIColor colorWithRed:0x4c/255.0 green:0x4c/255.0 blue:0x4c/255.0 alpha:1.0];
    
    [self addSubview:_subLabel];
}



@end
