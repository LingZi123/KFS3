//
//  AddRemandViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemandModel.h"


@protocol AddRemandViewControllerDelegate <NSObject>

-(void)addRemand:(RemandModel *)model;
-(void)updateRemand:(RemandModel *)model;
-(void)deleteRemand:(RemandModel *)model;

@end

@interface AddRemandViewController : UITableViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UIButton *dateBtn;
    __weak IBOutlet UIButton *timeBtn;
    __weak IBOutlet UIButton *repeatBtn;
    __weak IBOutlet UITextField *nameTextField;

    NSString *repeatStr;
    NSString *beginDateStr;
    NSString *timeStr;
    NSString *imagename;//图片
    NSString *name;
    
    __weak IBOutlet UIButton *deleteBtn;
    
    __weak IBOutlet UIButton *saveBtn;

}

@property(nonatomic,retain)RemandModel *remandmodel;
@property(nonatomic,assign) id<AddRemandViewControllerDelegate>delegate;

- (IBAction)dateBtnClick:(id)sender;

- (IBAction)timeBtnClick:(id)sender;
- (IBAction)repeatBtnClick:(id)sender;
- (IBAction)changeBtnClick:(id)sender;
- (IBAction)saveBtnClick:(id)sender;
- (IBAction)deleteBtnClick:(id)sender;
@end
