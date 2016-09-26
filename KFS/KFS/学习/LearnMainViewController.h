//
//  LearnMainViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRootViewController.h"

@interface LearnMainViewController :CommonRootViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *mytableView;
    UIScrollView *sc;
    UIButton *oldSelectTitleBtn;//选中的
}
@property(nonatomic,retain)NSMutableArray *titlemArray;
@property(nonatomic,retain)NSMutableArray *contentArray;
@end
