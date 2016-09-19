//
//  LoginMainViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRootViewController.h"
#import "LableTextFieldView.h"

@interface LoginViewController : CommonRootViewController<UITextFieldDelegate>{
    
    UIImageView *headImageView;
    LableTextFieldView *accountView;
    LableTextFieldView *pwdView;
}

@end
