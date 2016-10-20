//
//  FirstPageMainViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodView.h"
#import "GFRemandView.h"
#import "MyStateView.h"
#import "CommonRootViewController.h"
#import "GFSelfInvolvedView.h"
#import "GFDoctorSuggest.h"

@interface FirstPageMainViewController : CommonRootViewController<RemainViewDelegate,MoodViewDelegate>
{
    MoodView *firstView;
    MyStateView *mystateView;
    NSMutableArray *lastTwoArray;//最近俩提醒
    GFDoctorSuggest *docotorSegusetView;
    GFSelfInvolvedView *selfInvolvedView;//自评view
//    NSMutableArray *todayRemandArray;
}

@property(nonatomic,retain)NSMutableArray  *remandListArray;
@property(nonatomic,retain)GFRemandView *remandView;
@end
