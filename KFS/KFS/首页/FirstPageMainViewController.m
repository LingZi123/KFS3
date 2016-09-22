//
//  FirstPageMainViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "FirstPageMainViewController.h"
#import "AppDelegate.h"
#import "SetHelperViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "CommonHelper.h"

@interface FirstPageMainViewController ()

@end

@implementation FirstPageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeView{
    UIScrollView *bgview=[[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgview];
    //第一行面板
    firstView=[[MoodView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgview.frame), 165)];
    firstView.delegate=self;
    [bgview addSubview:firstView];
    
    //我的提醒
    _remandView=[[RemainView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(firstView.frame)+1, CGRectGetWidth(bgview.frame), 168)];
    _remandView.delegate=self;
    [bgview addSubview:_remandView];
    //我的状态
    
    mystateView=[[MyStateView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_remandView.frame)+1, CGRectGetWidth(bgview.frame), 200)];
    [bgview addSubview:mystateView];
    
    UIImageView *endImage=[[UIImageView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(mystateView.frame)+5, CGRectGetWidth(bgview.frame)-4, DE_Ration65*CGRectGetWidth(self.view.frame))];
    [endImage setImage:[UIImage imageNamed:@"任务"]];
    [bgview addSubview:endImage];
    
      bgview.contentSize=CGSizeMake(self.view.frame.size.width,firstView.frame.size.height+_remandView.frame.size.height+mystateView.frame.size.height+endImage.frame.size.height+80);
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求健康和心情
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMyMoodAndHealth];
    }) ;
    
    //请求提醒
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLastMyRemand];
//    }) ;
    //请求状态
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMyStatus];
    }) ;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark-RemainViewDelegate

-(void)goSetHelperPage{
    
    SetHelperViewController *setvc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"SetHelperViewController"];
    setvc.remandListArray=self.remandListArray;
    setvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setvc animated:YES];
}

#pragma mark-MoodViewDelegate

-(void)goGradePage{
    UIViewController *vc=[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor whiteColor];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)getMyMoodAndHealth{
    [firstView getMoodAndHealth];
}

-(void)getLastMyRemand{
    
    [self getRemandListFromLocal];
}
-(void)getMyStatus{
    
}

-(void)getRemandListFromServer{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakself=self;
    [manager GET:DE_UrlRemind parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        [hud hideAnimated:YES];
        if ([status isEqualToString:@"error"]) {
            //构造两个现实无提醒
            [weakself.remandView fullLastMyRemandWithArray:nil];
        }
        else{
            if (weakself.remandListArray==nil) {
                weakself.remandListArray=[[NSMutableArray alloc]init];
            }
            
            [weakself.remandListArray removeAllObjects];
            for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
                RemandModel *modelItem=[RemandModel getModelWithDic:dic];
                [weakself.remandListArray addObject:modelItem];
            }
            
            //存储
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:weakself.remandListArray];
            [defaults setObject:saveData forKey:DE_RemandList];
            [defaults synchronize];
            //选取两个最近的填充
            [weakself fullRemandView];
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

-(void)getRemandListFromLocal{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:DE_RemandList]];
    if (array) {
        if (self.remandListArray==nil) {
            self.remandListArray=[[NSMutableArray alloc]init];
        }
        [self.remandListArray removeAllObjects];
        for (RemandModel *model in array) {
            [self.remandListArray addObject:model];
        }
        [self fullRemandView];
    }
    if (self.remandListArray==nil) {
        [self getRemandListFromServer];
    }
}

-(void)fullRemandView{
    //选取两个最近的填充
    [self getLastTwoRemand];
    [self.remandView fullLastMyRemandWithArray:lastTwoArray];
}
//获取最近的两个提醒
-(void)getLastTwoRemand{
    if (self.remandListArray) {
        
        NSDateFormatter *fomatter=[[NSDateFormatter alloc]init];
        [fomatter setDateFormat:@"hh:mm:ss"];
        NSDate *now=[NSDate date];
        NSString *nowStr=[fomatter stringFromDate:now];
        
        //获取今天的星期
        NSString *currentWekday=[NSString stringWithFormat:@"%lD",(long)[[CommonHelper shareHeper]getWeekDay:now]];
//        if (todayRemandArray==nil) {
//            todayRemandArray=[[NSMutableArray alloc]init];
//        }
        if (lastTwoArray==nil) {
            lastTwoArray=[[NSMutableArray alloc]init];
        }
        [lastTwoArray removeAllObjects];
//        [todayRemandArray removeAllObjects];
        for (RemandModel *model in self.remandListArray) {
            if (model.isOpen&&[model.isRepeat containsString:currentWekday]) {
                
                NSInteger todayS=[[CommonHelper shareHeper]getMinitByTimeStr:nowStr];
                NSInteger modelS=[[CommonHelper shareHeper]getMinitByTimeStr:model.excuteTime];
                
                if (modelS>todayS) {
                    [lastTwoArray addObject:model];
                }
            }
        }
        
    }
}

@end
