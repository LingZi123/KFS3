//
//  GFWeekView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GFWeekViewDelegate <NSObject>

-(void)didWeekSelectedFinished:(NSMutableArray *)array weekStr:(NSString *)weekStr;

@end

@interface GFWeekView : UIView
{
    NSString *resultStr;
    NSInteger count;//选择的数量
    NSMutableArray *btnArray;
    UIButton *satBtn;
    UIButton *weekendBtn;
    
}
@property (strong, nonatomic) IBOutlet UIView *innerView;

@property(nonatomic,retain)UIViewController *parentVC;
@property(nonatomic,assign)id<GFWeekViewDelegate>delegate;


+ (instancetype)defaultPopupView:(CGFloat)width;

- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)okBtnClick:(id)sender;
- (IBAction)weekBtnClick:(id)sender;



@end
