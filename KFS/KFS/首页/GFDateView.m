//
//  GFDateView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFDateView.h"
#import "LewPopupViewAnimationSpring.h"

@implementation GFDateView


-(instancetype)initWithFrame:(CGRect)frame datemode:(UIDatePickerMode)datemode{
    self=[super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        datePickview.locale = locale;
        dateMode=datemode;
        datePickview.datePickerMode=dateMode;
        dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        if (dateMode==UIDatePickerModeDate) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];//四个y就是2014－10-15，2个y就是14-10-15，这是输出字符串的时候用到的
        }
        else{
            [dateFormatter setDateFormat:@"HH:mm:ss"];
        }
    }
    return self;
}
+ (instancetype)defaultPopupView:(CGFloat)width datemode:(UIDatePickerMode)datemode{
    GFDateView *v=[[GFDateView alloc]initWithFrame:CGRectMake(0, 0, width, 230) datemode:datemode];
    return v;
}

- (IBAction)okBtnClick:(id)sender {
    
    NSDate *date=datePickview.date;
    NSString *datestr=[dateFormatter stringFromDate:date];
    
    if (dateMode==UIDatePickerModeTime) {
        [self.delegate didTimeSelectedFinished:datestr];
    }
    else{
         [self.delegate didDateSelectedFinished:datestr];
    }
   
    NSLog(@"%@",datestr);
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)cancelBtnClick:(id)sender {
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
//    [_parentVC lew_dismissPopupView];
}
@end
