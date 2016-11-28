//
//  GFScoreView.h
//  KFS
//
//  Created by PC_201310113421 on 16/10/19.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GFSelfInvolvedViewDelegate <NSObject>

-(void)anserQuestionClick;
-(void)seeSoreTotal;

@end

@interface GFSelfInvolvedView : UIView
{
    UIButton *soreTotoalBtn;//进入分数统计，按照每天时间
    UIButton *soreBtn;//分数按钮
    UILabel *locationLabel;
}

@property(nonatomic,assign) id<GFSelfInvolvedViewDelegate> delegate;
-(void)refashScore:(NSString *)score;

@end
