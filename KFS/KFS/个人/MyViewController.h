//
//  MyViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/12.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UITableViewController{
    
    __weak IBOutlet UIImageView *headImageView;
    
    __weak IBOutlet UILabel *mainLabel;

    __weak IBOutlet UILabel *subLabel;
}

- (IBAction)logoutBtnClick:(id)sender;
@end
