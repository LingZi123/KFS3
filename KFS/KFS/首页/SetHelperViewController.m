//
//  SetHelperViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "SetHelperViewController.h"
#import "AppDelegate.h"
#import "AddRemandViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "RemandModel.h"
#import "RemandNotifManager.h"

@interface SetHelperViewController ()

@end

@implementation SetHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title=@"助手设置";
    UIBarButtonItem *backImte=[[UIBarButtonItem alloc]init];
    backImte.title=@"返回" ;
    self.navigationItem.backBarButtonItem=backImte;

    UIBarButtonItem *rigthBar=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem=rigthBar;
    tastTableview.tableFooterView=[[UIView alloc]init];
    tastTableview.rowHeight=96;
    //注册cell
    [tastTableview registerNib:[UINib nibWithNibName:@"RemandSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"remandsetCell"];
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark-添加任务
-(void)addTask:(UIBarButtonItem *)sender{
    
    AddRemandViewController *vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"AddRemandViewController"];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.remandListArray) {
        return  self.remandListArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"remandsetCell";
    RemandSetTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[RemandSetTableViewCell alloc]init];
    }
    
    RemandModel *model=[self.remandListArray objectAtIndex:indexPath.row];
    cell.myTitleLabel.text=model.name;
//    cell.imageView.image=[UIImage imageNamed:@"appLogo"];
    [cell.controlSwitch setOn:model.isOpen];
    cell.detailLabel.text=[model getRepeatDis:model.isRepeat];
    cell.detailLabel2.text=[model.excuteTime substringWithRange:NSMakeRange(0, 5)];
    cell.datamodel=model;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"deletecell");
        
        RemandModel *selectdmodel=[self.remandListArray objectAtIndex:indexPath.row];
        
        [self deleteRemandModelFromServer:selectdmodel];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RemandModel *selectdmodel=[self.remandListArray objectAtIndex:indexPath.row];
    AddRemandViewController *vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"AddRemandViewController"];
    vc.delegate=self;
    vc.remandmodel=selectdmodel;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark-AppDelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-AddRemandViewControllerDelegate
-(void)addRemand:(RemandModel *)model{
    if (self.remandListArray==nil) {
        self.remandListArray=[[NSMutableArray alloc]init];
    }
    [self.remandListArray addObject:model];
      [tastTableview reloadData];
    //存到系统
    [self saveToLocal];
}

-(void)deleteRemand:(RemandModel *)model{
    [self deleteRemandModelFromServer:model];
}

-(void)updateRemand:(RemandModel *)model{
    if (self.remandListArray) {
        for (RemandModel *item in self.remandListArray) {
            if (item.modelId==model.modelId) {
                item.name=model.name;
                item.beginDate=model.beginDate;
                item.excuteTime=model.excuteTime;
                item.isRepeat=model.isRepeat;
                break;
            }
        }
    }
    
    [tastTableview reloadData];
    [self saveToLocal];
}

-(void)saveToLocal{
    //存到系统
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *savedata=[NSKeyedArchiver archivedDataWithRootObject:self.remandListArray];
    [defaults setObject:savedata forKey:DE_RemandList];
    [defaults synchronize];
}
-(void)deleteRemandModelFromServer:(RemandModel *)model{
    
    //检查网络
    if ([self appdelegate].netstatus!=ReachableViaWiFi&&[self appdelegate].netstatus!=ReachableViaWWAN){
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text=@"无网络，请打开数据流量或等待wifi下使用";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.0f];
        
        return;
    }
    
    AFHTTPSessionManager *manamger=[AFHTTPSessionManager manager];
    [manamger.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    MBProgressHUD  *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakself=self;
    
    [manamger DELETE:[NSString stringWithFormat:@"%@/%lD",DE_UrlRemind,(long)model.modelId] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            [hud hideAnimated:YES];
            [weakself.remandListArray removeObject:model];
            [tastTableview reloadData];
            
            
            //移除本地
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *data=[NSKeyedArchiver archivedDataWithRootObject:weakself.remandListArray];
            [defaults setObject:data forKey:DE_RemandList];
            [defaults synchronize];
            
            //移除通知
            [[RemandNotifManager shareManager]deleteNotifWithModel:model];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}



@end
