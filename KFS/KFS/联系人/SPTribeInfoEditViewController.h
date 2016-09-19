//
//  SPTribeInfoEditViewController.h
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

typedef enum : NSUInteger {
    SPTribeInfoEditModeModify,
    SPTribeInfoEditModeCreateNormal,
    SPTribeInfoEditModeCreateMultipleChat,
} SPTribeInfoEditMode;

@interface SPTribeInfoEditViewController : UIViewController{
    
    __weak IBOutlet UIButton *multipleBtn;
    __weak IBOutlet UIButton *normalBtn;
}

@property (nonatomic, strong) YWTribe *tribe;
@property (nonatomic, assign) SPTribeInfoEditMode mode;

- (IBAction)modelBtnClick:(id)sender;


@end
