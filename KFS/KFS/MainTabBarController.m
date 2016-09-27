//
//  MainTabBarController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/30.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MainTabBarController.h"
#import "FirstPageMainViewController.h"
#import "ContactMainViewController.h"
#import "LearnMainViewController.h"
#include "MyViewController.h"
#import "AppDelegate.h"
#import "SPTribeSystemConversationViewController.h"

#import <WXOUIModule/YWConversationListViewController.h>
//#import "YWConversationListViewController+UIViewControllerPreviewing.h"
#import "SPKitExample.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeControllers{
    FirstPageMainViewController *vc1=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"FirstPageMainViewController"];
    
    ContactMainViewController *vc2=[[self appdelegate].storyboard  instantiateViewControllerWithIdentifier:@"ContactMainViewController"];
    vc2.mode=SPContactListModeNormal;
    
    LearnMainViewController *vc3=[[self appdelegate].storyboard  instantiateViewControllerWithIdentifier:@"LearnMainViewController"];
    
    MyViewController *vc4=[[self appdelegate].storyboard  instantiateViewControllerWithIdentifier:@"MyViewController"];
    
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
    nav1.title=@"动态";
    nav1.tabBarItem.title=@"首页";
    [nav1.tabBarItem setSelectedImage:[UIImage imageNamed:@"亮动态"]];
    [nav1.tabBarItem setImage:[UIImage imageNamed:@"灰动态"]];
    [nav1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DE_BgColorPink,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    //消息
    YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
    
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:conversationListController];
    [nav5.tabBarItem setSelectedImage:[UIImage imageNamed:@"亮消息"]];
    [nav5.tabBarItem setImage:[UIImage imageNamed:@"灰消息"]];
    [nav5.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DE_BgColorPink,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [nav5.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"] forBarMetrics:UIBarMetricsDefault];
    [nav5.navigationBar setTintColor:[UIColor whiteColor]];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    nav5.navigationBar.titleTextAttributes = dict;

    
    __weak typeof(nav5) weakController = nav5;
    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
        NSString *badgeValue = aCount > 0 ?[ @(aCount) stringValue] : nil;
        weakController.tabBarItem.badgeValue = badgeValue;
    }];
    
    
    [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];
    
    nav5.title=@"消息";

    
    __weak __typeof(conversationListController) weakConversationListController = conversationListController;
    conversationListController.didSelectItemBlock = ^(YWConversation *aConversation) {
        
        
        if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
            YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
            [customConversation markConversationAsRead];
            
            if ([customConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                UIViewController *controller = [[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"SPTribeSystemConversationViewController"];
                [weakConversationListController.navigationController pushViewController:controller animated:YES];
            }
            else if ([customConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
//                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://bbs.aliyun.com/searcher.php?step=2&method=AND&type=thread&verify=d26d3c6e63c0b37d&sch_area=1&fid=285&sch_time=all&keyword=汇总" andImkit:[SPKitExample sharedInstance].ywIMKit];
//                [controller setHidesBottomBarWhenPushed:YES];
//                [controller setTitle:@"云旺iOS精华问题"];
//                [weakConversationListController.navigationController pushViewController:controller animated:YES];
            }
            else {
                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
                [controller setHidesBottomBarWhenPushed:YES];
                [controller setTitle:@"功能介绍"];
                [weakConversationListController.navigationController pushViewController:controller animated:YES];
            }
        }
        else {
            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation
                                                                        fromNavigationController:weakConversationListController.navigationController];
        }
    };
    
    conversationListController.didDeleteItemBlock = ^ (YWConversation *aConversation) {
        if ([aConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
            [[[SPKitExample sharedInstance].ywIMKit.IMCore getConversationService] removeConversationByConversationId:[SPKitExample sharedInstance].tribeSystemConversation.conversationId error:NULL];
        }
    };
    
//    conversationListController.ywcsTrackTitle = @"会话列表";
    
    // 会话列表空视图
    if (conversationListController)
    {
        CGRect frame = CGRectMake(0, 0, 100, 100);
        UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
        imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        [viewForNoData addSubview:imageView];
        
        conversationListController.viewForNoData = viewForNoData;
    }
    
    {
        __weak typeof(conversationListController) weakController = conversationListController;
        [conversationListController setViewDidLoadBlock:^{
            //                weakController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:weakSelf action:@selector(addCustomConversation)];
            
            //                // 加入搜索栏
            //                weakController.tableView.tableHeaderView = weakController.searchBar;
            //                CGPoint contentOffset = CGPointMake(0, weakController.searchBar.frame.size.height);
            //                [weakController.tableView setContentOffset:contentOffset animated:NO];
            
            if ([weakController respondsToSelector:@selector(traitCollection)]) {
                UITraitCollection *traitCollection = weakController.traitCollection;
                if ( [traitCollection respondsToSelector:@selector(forceTouchCapability)] ) {
                    if (traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                        [weakController registerForPreviewingWithDelegate:weakController sourceView:weakController.tableView];
                    }
                }
            }
        }];
    }
    
    
   
//    UITabBarItem *item = [self _makeItemWithTitle:@"消息" normalName:@"news_nor" selectedName:@"news_pre" tag:100];
//    [nav5 setTabBarItem:item];

    
    
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:vc2];
    nav2.title=@"联系人";
    [nav2.tabBarItem setSelectedImage:[UIImage imageNamed:@"联系人选中"]];
    [nav2.tabBarItem setImage:[UIImage imageNamed:@"联系人"]];
    [nav2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DE_BgColorPink,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:vc3];
    nav3.title=@"学习";
    [nav3.tabBarItem setSelectedImage:[UIImage imageNamed:@"亮学习"]];
    [nav3.tabBarItem setImage:[UIImage imageNamed:@"灰学习"]];
    [nav3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DE_BgColorPink,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:vc4];
    nav4.title=@"我的";
    [nav4.tabBarItem setSelectedImage:[UIImage imageNamed:@"亮我的"]];
    [nav4.tabBarItem setImage:[UIImage imageNamed:@"灰我的"]];
    [nav4.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DE_BgColorPink,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    NSArray *titleArray=@[nav1,nav5,nav2,nav3,nav4];
    self.viewControllers=titleArray;
    self.tabBar.tintColor=DE_BgColorPink;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
