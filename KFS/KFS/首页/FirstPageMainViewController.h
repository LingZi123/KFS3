//
//  FirstPageMainViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodView.h"
#import "RemainView.h"
#import "MyStateView.h"
#import "CommonRootViewController.h"

@interface FirstPageMainViewController : CommonRootViewController<RemainViewDelegate,MoodViewDelegate>
{
    MoodView *firstView;
    RemainView *remandView;
    MyStateView *mystateView;
}
@end
