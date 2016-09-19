//
//  PopViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPopViewControllerDelegate <NSObject>

-(void)didCellSelected:(NSInteger)row viewController:(UIViewController *)vc;

@end
@interface PopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mytableView;
    NSArray *dataArray;
    NSArray *arr1;
}

@property(nonatomic,assign)id<MyPopViewControllerDelegate>delegate;

@end
