//
//  SPTribeConversationViewController.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/20.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPTribeConversationViewController.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWIMKit.h>
#import "SPTribeProfileViewController.h"
#import "AppDelegate.h"

@implementation SPTribeConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *aryItems = self.navigationItem.rightBarButtonItems;
    NSMutableArray *aryNewItems = [NSMutableArray array];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(tribeProfileBarButtonItemPressed:)];
    
    [aryNewItems addObject:item];
    [aryNewItems addObjectsFromArray:aryItems];
    self.navigationItem.rightBarButtonItem = item;

    [self addTribeCallbackBlocks];
}


- (void)addTribeCallbackBlocks {
    __weak __typeof(self) weakSelf = self;
    [[self.kitRef.IMCore getTribeService] addDidExpelFromTribeBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        if ([tribeID isEqualToString:[weakSelf tribeConversation].tribe.tribeId]) {
            [weakSelf exitConversation];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];

    [[self.kitRef.IMCore getTribeService] addTribeDidDisbandBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        if ([tribeID isEqualToString:[weakSelf tribeConversation].tribe.tribeId]) {
            [weakSelf exitConversation];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];

    [[self.kitRef.IMCore getTribeService] addMemberDidExitBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[weakSelf.kitRef.IMCore getLoginService] currentLoginedUser];
        if ([tribeID isEqualToString:[weakSelf tribeConversation].tribe.tribeId]
            && [person isEqualToPerson:me]) {
            [weakSelf exitConversation];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)removeTribeCallbackBlocks {
    [[self.kitRef.IMCore getTribeService] removeDidExpelFromTribeBlockForKey:self.description];
    [[self.kitRef.IMCore getTribeService] removeMemberDidExitBlockForKey:self.description];
    [[self.kitRef.IMCore getTribeService] removeTribeDidDisbandBlockForKey:self.description];
}
- (void)exitConversation {
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index != NSNotFound && index > 0) {
        UIViewController *vc = self.navigationController.viewControllers[index - 1];
        [self.navigationController popToViewController:vc animated:YES];
    }
}
- (void)dealloc {
    [self removeTribeCallbackBlocks];
}

- (YWTribeConversation *)tribeConversation {
    if ([self.conversation isKindOfClass:[YWTribeConversation class]]) {
        return (YWTribeConversation *)self.conversation;
    }
    return nil;
}

- (void)tribeProfileBarButtonItemPressed:(id)sender {
    SPTribeProfileViewController *controller =  [[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"SPTribeProfileViewController"];
    if (controller) {
        controller.tribe = [self tribeConversation].tribe;

        [self.navigationController pushViewController:controller animated:YES];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//
//        [self presentViewController:navigationController
//                           animated:YES
//                         completion:nil];
    }
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
