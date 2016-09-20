//
//  RegistTableViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/18.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface RegistTableViewController : UITableViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *pwdField;
    __weak IBOutlet UITextField *vertyCodeField;
    __weak IBOutlet UITextField *mynameFiled;
    __weak IBOutlet UIButton *getVerityCodeBtn;
    NSInteger timeCount;
}

- (IBAction)getVerityCodeBtnClick:(id)sender;

- (IBAction)registAndLoginBtnClick:(id)sender;

@end
