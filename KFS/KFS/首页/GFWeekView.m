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

-(void)fullWeekBtn:(NSMutableArray *)repeatArray{
    if (repeatArray==nil) {
        return;
    }
    if (btnArray==nil) {
        btnArray=[[NSMutableArray alloc]init];
    }
    [btnArray removeAllObjects];
    
    for (int i=0;i<repeatArray.count;i++) {
        if ([repeatArray[i] isEqualToString:@"1"] ) {
            
            UIButton *btn=(UIButton *)[self viewWithTag:100+i+1];
            btn.selected=YES;
            [btnArray addObject:btn];
        }
    }
}
- (IBAction)cancelBtnClick:(id)sender {
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}

- (IBAction)okBtnClick:(id)sender {
    resultStr=@"";
    NSString *resultStr2=@"";
    if (btnArray) {
        if (btnArray.count==7) {
            resultStr=@"每天";
            resultStr2=DE_Everyday;

        }
        else if (btnArray.count==5&&![btnArray containsObject:satBtn]&&![btnArray containsObject:weekendBtn]){
            resultStr=@"工作日";
            resultStr2=DE_JobDay;
        }
        else if (btnArray.count==2&&[btnArray containsObject:satBtn]&&[btnArray containsObject:weekendBtn]){
            resultStr=@"周末";
            resultStr2=DE_WeekendDay;
            
        }
        else{
            for (UIButton *item in btnArray) {
                
                resultStr=[resultStr stringByAppendingString:[NSString stringWithFormat:@"%@、",item.titleLabel.text]];
                if ([item.titleLabel.text isEqualToString:@"周一"]) {
                    resultStr2=[NSString stringWithFormat:@"%@1#",resultStr2];
                }
                if ([item.titleLabel.text isEqualToString:@"周二"]) {
                    resultStr2=[NSString stringWithFormat:@"%@2#",resultStr2];

                }
                if ([item.titleLabel.text isEqualToString:@"周三"]) {
                    resultStr2=[NSString stringWithFormat:@"%@3#",resultStr2];
                }
                if ([item.titleLabel.text isEqualToString:@"周四"]) {
                    resultStr2=[NSString stringWithFormat:@"%@4#",resultStr2];
                }
                if ([item.titleLabel.text isEqualToString:@"周五"]) {
                    resultStr2=[NSString stringWithFormat:@"%@5#",resultStr2];

                }
                if ([item.titleLabel.text isEqualToString:@"周六"]) {
                    resultStr2=[NSString stringWithFormat:@"%@6#",resultStr2];

                }
                if ([item.titleLabel.text isEqualToString:@"周日"]) {
                    resultStr2=[NSString stringWithFormat:@"%@7#",resultStr2];
                }
               
            }
            resultStr2=[resultStr2 substringWithRange:NSMakeRange(0,resultStr2.length-1)];
            resultStr=[resultStr substringToIndex:resultStr.length-1];
        }
    }
    else{
        resultStr2=@"null";
    }
    
    [self.delegate didWeekSelectedFinished:resultStr2 weekStr:resultStr];
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
