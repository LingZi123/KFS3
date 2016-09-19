//
//  GFWeekView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFWeekView.h"
#import "LewPopupViewAnimationSpring.h"

@implementation GFWeekView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
    }
    return self;
}
+ (instancetype)defaultPopupView:(CGFloat)width{
    GFWeekView *v=[[GFWeekView alloc]initWithFrame:CGRectMake(0, 0, width, 230)];
    return v;
}

- (IBAction)cancelBtnClick:(id)sender {
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)okBtnClick:(id)sender {
    resultStr=@"";
    NSMutableArray *resultArray=[[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    if (btnArray) {
        if (btnArray.count==7) {
            resultStr=@"每天";
            for (int i=0; i<7;i++) {
                resultArray[i]=@"1";
            }
        }
        else if (btnArray.count==5&&![btnArray containsObject:satBtn]&&![btnArray containsObject:weekendBtn]){
            resultStr=@"工作日";
            for (int i=0; i<5; i++) {
                resultArray[i]=@"1";
            }
        }
        else if (btnArray.count==2&&[btnArray containsObject:satBtn]&&[btnArray containsObject:weekendBtn]){
            resultStr=@"周末";
            
            resultArray[5]=@"1";
            resultArray[6]=@"1";
            
        }
        else{
            for (UIButton *item in btnArray) {
                
                resultStr=[resultStr stringByAppendingString:[NSString stringWithFormat:@"%@、",item.titleLabel.text]];
                if ([item.titleLabel.text isEqualToString:@"周一"]) {
                     resultArray[0]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周二"]) {
                    resultArray[1]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周三"]) {
                    resultArray[2]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周四"]) {
                    resultArray[3]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周五"]) {
                    resultArray[4]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周六"]) {
                    resultArray[5]=@"1";
                }
                if ([item.titleLabel.text isEqualToString:@"周日"]) {
                    resultArray[6]=@"1";
                }
            }
            resultStr=[resultStr substringToIndex:resultStr.length-1];
        }
    }
    
    [self.delegate didWeekSelectedFinished:resultArray weekStr:resultStr];
     [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)weekBtnClick:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    if (satBtn==nil&&btn.tag==106) {
        satBtn=btn;
    }
    if (weekendBtn==nil&&btn.tag==107) {
        weekendBtn=btn;
    }
    if (btnArray==nil) {
        btnArray=[[NSMutableArray alloc]init];
    }
    if ([btnArray containsObject:btn]) {
        btn.selected=NO;
        //背景图片改变
        [btnArray removeObject:btn];
    }
    else{
        //btn图片改变
        btn.selected=YES;
        [btnArray addObject:btn];
    }
    
}
@end
