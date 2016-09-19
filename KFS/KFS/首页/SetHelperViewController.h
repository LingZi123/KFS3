//
//  SetHelperViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemandSetTableViewCell.h"

@interface SetHelperViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tastTableview;
    NSMutableArray *dataMArray;//数据
}

@end
