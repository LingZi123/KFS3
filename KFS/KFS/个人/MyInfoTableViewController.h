//
//  MyInfoTableViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/10/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UIButton *imageBtn;
    
    __weak IBOutlet UILabel *usernameLabel;
    
    __weak IBOutlet UIButton *sexNanBtn;
    __weak IBOutlet UIButton *sexNvBtn;
    __weak IBOutlet UITextField *heightField;
    __weak IBOutlet UITextField *weightField;
    __weak IBOutlet UITextField *trueNameField;
    UIBarButtonItem *rightBar;
    
    UIButton *oldSelectedBtn;
    NSString *headImageStr;
     CGRect originframe;
    BOOL buttonEnble;
    NSString *oldHeadImageUrl;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)imageBtnClick:(id)sender;
- (IBAction)sexBtnClick:(id)sender;
@end
