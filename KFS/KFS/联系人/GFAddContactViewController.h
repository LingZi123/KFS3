//
//  GFAddContactViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFAddContactViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableDictionary *cachedDisplayNames;
@property (strong, nonatomic) NSMutableDictionary *cachedAvatars;

- (IBAction)searchBtnClick:(id)sender;
@end
