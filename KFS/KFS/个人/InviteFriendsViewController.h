//
//  InviteFriendsViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFShareView.h"

@interface InviteFriendsViewController : UIViewController<GFShareViewDelegate>{
    GFShareView *shareView;
    UIColor *origiColor;//原始背景色
    __weak IBOutlet UIView *topView;
    NSData *imageData;
    __weak IBOutlet UIImageView *shareImageview;
}

@property(nonatomic,assign)BOOL isHidenShareView;//是否显示分享页面
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)beginShare:(id)sender;
@end
