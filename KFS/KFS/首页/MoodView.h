//
//  MoodView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodUnitView.h"

@protocol  MoodViewDelegate<NSObject>

-(void)goGradePage;

@end

@interface MoodView : UIView
{
    MoodUnitView *xinqingview;
    MoodUnitView *jiankangview;
}

@property(nonatomic,assign)id<MoodViewDelegate> delegate;
@end
