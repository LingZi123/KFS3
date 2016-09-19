//
//  GFDateView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GFDateViewDelegate <NSObject>

@optional
-(void)didDateSelectedFinished:(NSString *)dateStr;
-(void)didTimeSelectedFinished:(NSString *)timeStr;

@end

@interface GFDateView : UIView
{
    
    __weak IBOutlet UIDatePicker *datePickview;
    UIDatePickerMode dateMode;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,assign)id<GFDateViewDelegate> delegate;


- (IBAction)okBtnClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;
+ (instancetype)defaultPopupView:(CGFloat)width datemode:(UIDatePickerMode)datemode;

@end
