//
//  AppDelegate.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabBarController.h"
#import "UserInfoModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,retain)MainTabBarController *mainTabbarv;//主界面
@property(nonatomic,retain)UINavigationController *loginNav;//登录界面
@property(nonatomic,retain)UIStoryboard *storyboard;//界面
@property(nonatomic,retain)NSString *token;
@property(nonatomic,retain)UserInfoModel *userInfo;
@property(nonatomic,retain)UIImage *headImage;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)makeMianView;
-(void)makeLoginView;
@end

