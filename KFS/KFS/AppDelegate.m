//
//  AppDelegate.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "sdkCall.h"
#import "SPKitExample.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //向阿里注册
    [[SPKitExample sharedInstance]callThisInDidFinishLaunching];
    //向微信注册
    [WXApi registerApp:DE_WeChatAppId];
    //注册腾讯qq
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelled) name:kLoginCancelled object:[sdkCall getinstance]];

    

    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor=DE_BgColorPink;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *noteSetting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:noteSetting];
    }
//     [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    //给界面赋值
    _storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path=NSHomeDirectory();
//    NSLog(documentsDirectory);
    
//    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//
//     NSLog(@"%@", localNotifications);
//    for (UILocalNotification *itme in localNotifications) {
//        NSLog(@"%@",itme.userInfo);
//        
//        [[UIApplication sharedApplication]cancelLocalNotification:itme];
//
//    }
    
    
    
    //获取是否已经登录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL isLogin=[[defaults objectForKey:DE_IsLogin]boolValue];
   
    //如果登录进入主界面,否则进入登录界面
    if (isLogin) {
        
        NSData *userdata=[defaults objectForKey:DE_UserInfo];
        self.userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:userdata];
        self.token=[defaults objectForKey:DE_Token];
        NSData *headImageData=[defaults objectForKey:DE_PhotoImage];
        self.headImage=[UIImage imageWithData:headImageData];
        
         [self makeMianView];
        [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:self.userInfo.username passWord:self.userInfo.pwd preloginedBlock:^{
            
        } successBlock:^{
            
          
            [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:[_mainTabbarv.viewControllers objectAtIndex:1]];
            
        } failedBlock:^(NSError *aError) {
//            if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"登录失败, 可以使用游客登录。\n（如在调试，请确认AppKey、帐号、密码是否正确。）" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"游客登录", nil];
//                    [as showInView:weakSelf.view];
//                });
//            }
            
        }
         ];

        
    }
    else{
        [self makeLoginView];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber=0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    application.applicationIconBadgeNumber=0;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.gf.KFS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KFS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KFS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark-根试图
-(void)makeMianView{
    if (_mainTabbarv==nil||_mainTabbarv==(id)[NSNull null]) {
        _mainTabbarv=[[MainTabBarController alloc]init];
    }
    
    _mainTabbarv.selectedIndex=0;
    self.window.rootViewController=_mainTabbarv;
    
}
-(void)makeLoginView{
    if (_loginNav==nil||_loginNav==(id)[NSNull null]) {
        LoginViewController *vc=[[LoginViewController alloc]init];
        _loginNav=[[UINavigationController alloc]initWithRootViewController:vc];
    }
    if (_loginNav.viewControllers.count>1) {
        [_loginNav popToRootViewControllerAnimated:YES];
    }
    self.window.rootViewController=_loginNav;
}

#pragma mark-qq分享
#pragma mark message
- (void)loginSuccessed
{
 }

- (void)loginFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void) loginCancelled
{
    //do nothing
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

@end
