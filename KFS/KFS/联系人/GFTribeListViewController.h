//
//  GFTribeListViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/7.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFTribeListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,retain)  UITableView *tribeTableView;
@property (nonatomic, strong) NSMutableDictionary *groupedTribes;
@end
