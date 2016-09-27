//
//  ForgetPwdTableViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdTableViewController : UITableViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UITextField *newPwdTextField;
    __weak IBOutlet UITextField *verityCodeField;
    __weak IBOutlet UIButton *sendVerityCodeBtn;
    
    NSString *username;
    NSString *newpwd;
    NSString *codes;
    NSInteger timeCount;
}
- (IBAction)sendVerityCodeBtnClick:(id)sender;
- (IBAction)saveBtnClick:(id)sender;
@end
