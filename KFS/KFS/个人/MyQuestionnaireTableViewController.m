//
//  MyQuestionnaireTableViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/21.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MyQuestionnaireTableViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface MyQuestionnaireTableViewController ()

@end

@implementation MyQuestionnaireTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"所有问卷";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self getQuestionsFormServer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *indentif=@"questionMainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentif forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentif];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

    
    return cell;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)getQuestionsFormServer{
    
    //检查网络
    if ([self appdelegate].netstatus!=ReachableViaWiFi&&[self appdelegate].netstatus!=ReachableViaWWAN){
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text=@"无网络，请打开数据流量或等待wifi下使用";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.0f];
        
        return;
    }
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager GET:DE_UrlFindUserAllProblem parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            [hud hideAnimated:YES];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
    
}
@end
