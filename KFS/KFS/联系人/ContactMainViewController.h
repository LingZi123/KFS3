//
//  ContactMainViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonRootViewController.h"
#import "PopViewController.h"
#import <WXOpenIMSDKFMWK/YWServiceDef.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

typedef enum : NSUInteger {
    SPContactListModeNormal,
    SPContactListModeSingleSelection,
    SPContactListModeMultipleSelection
} SPContactListMode;


@class ContactMainViewController;
@protocol ContactMainViewControllerDelegate <NSObject>
- (void)contactListController:(ContactMainViewController *)controller
           didSelectPersonIDs:(NSArray *)personIDs;
@end

@interface ContactMainViewController :CommonRootViewController<UIPopoverPresentationControllerDelegate,MyPopViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem *addBar;
    PopViewController *po;
    NSMutableArray *titleArray;
    NSArray *sectionOneArray;
}



@property (nonatomic, strong) YWFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)  UITableView *contactTableView;
@property (nonatomic, assign) SPContactListMode mode;
@property (nonatomic, strong) NSArray *excludedPersonIDs;
@property (nonatomic, weak) id<ContactMainViewControllerDelegate> delegate;
@property (nonatomic, strong) YWConversation *conversation;

@end
