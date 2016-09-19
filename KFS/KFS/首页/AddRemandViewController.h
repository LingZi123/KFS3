//
//  AddRemandViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRemandViewController : UITableViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UIButton *dateBtn;
    __weak IBOutlet UIButton *timeBtn;
    __weak IBOutlet UIButton *repeatBtn;
    __weak IBOutlet UITextField *nameTextField;
    NSDate *beginDate;//开始日期
    NSDate *beginTime;//开始时间
    NSMutableArray *repeatArray;//重复时间
    NSString *repeatStr;
    NSString *beginDateStr;
    NSString *timeStr;
    NSString *imagename;//图片
    
    
    NSMutableDictionary *datamdic;
}
- (IBAction)dateBtnClick:(id)sender;

- (IBAction)timeBtnClick:(id)sender;
- (IBAction)repeatBtnClick:(id)sender;
- (IBAction)changeBtnClick:(id)sender;
- (IBAction)saveBtnClick:(id)sender;
- (IBAction)deleteBtnClick:(id)sender;
@end
