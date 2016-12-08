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
#import "ProblemViewController.h"

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
    UIScrollView *bgview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:bgview];
    
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgview.frame), 200)];
    topImageView.image=[UIImage imageNamed:@"首页头部"];
    [bgview addSubview:topImageView];
    
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 31, CGRectGetWidth(bgview.frame)-200, 22)];
//    titleLabel.text=@"我的状态";
    
//    titleLabel.font=[UIFont systemFontOfSize:18];
//    titleLabel.textAlignment=NSTextAlignmentCenter;
////    titleLabel.textColor=DE_BgColorPink;
//    [bgview addSubview:titleLabel];
    //第一行面板
//    firstView=[[MoodView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgview.frame), 165)];
//    firstView.delegate=self;
//    [bgview addSubview:firstView];
    
    selfInvolvedView=[[GFSelfInvolvedView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgview.frame), 200)];
    selfInvolvedView.delegate=self;
    [bgview addSubview:selfInvolvedView];
    
    //我的提醒
    _remandView=[[GFRemandView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selfInvolvedView.frame)+1, CGRectGetWidth(bgview.frame), 125)];
    _remandView.delegate=self;
    [bgview addSubview:_remandView];
    
    
    //医生建议
    docotorSegusetView=[[GFDoctorSuggest alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_remandView.frame)+1, CGRectGetWidth(bgview.frame), 150)];
    
    [bgview addSubview:docotorSegusetView];
    //我的状态
    
    mystateView=[[MyStateView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(docotorSegusetView.frame)+5, CGRectGetWidth(bgview.frame), 200)];
    [bgview addSubview:mystateView];
    
    UIImageView *endImage=[[UIImageView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(mystateView.frame)+5, CGRectGetWidth(bgview.frame)-4, DE_Ration65*CGRectGetWidth(self.view.frame))];
    [endImage setImage:[UIImage imageNamed:@"任务"]];
    [bgview addSubview:endImage];
    
      bgview.contentSize=CGSizeMake(self.view.frame.size.width,topImageView.frame.size.height+_remandView.frame.size.height+docotorSegusetView.frame.size.height+mystateView.frame.size.height+endImage.frame.size.height+80);
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self appdelegate].score) {
        [selfInvolvedView refashScore:[self appdelegate].score];
    }
    
//    self.navigationController.navigationBarHidden=YES;
    
    //请求健康和心情
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getMyMoodAndHealth];
//    }) ;
    
    //请求提醒
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLastMyRemand];
//    }) ;
    //请求状态
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getMyStatus];
//    }) ;
    
    //医生建议
    if ([self appdelegate].doctorSuggest) {
        docotorSegusetView.titleLabel.text=[self appdelegate].doctorSuggest;
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden=NO;
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
    
    [self getRemandListFromServer];
}
-(void)getMyStatus{
    
}

-(void)getRemandListFromServer{
    
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
    
    
    __weak typeof(self) weakself=self;
    [manager GET:DE_UrlRemind parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            
            [weakself getRemandListFromLocal];
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
        [weakself getRemandListFromLocal];
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
    //从本地获取
    if (self.remandListArray==nil||self.remandListArray.count<=0) {
        //构造两个现实无提醒
        [self.remandView fullLastMyRemandWithArray:nil];
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
        
        NSDateFormatter *timefomatter=[[NSDateFormatter alloc]init];
        [timefomatter setDateFormat:@"HH:mm:ss"];
        NSDateFormatter *datefomatter=[[NSDateFormatter alloc]init];
        [datefomatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *now=[NSDate date];
        NSString *nowtimeStr=[timefomatter stringFromDate:now];
        NSString *nowDateStr=[datefomatter stringFromDate:now];
        
        //获取今天的星期
        NSString *currentWekday=[[CommonHelper shareHeper]getWeekDay:now];

        if (lastTwoArray==nil) {
            lastTwoArray=[[NSMutableArray alloc]init];
        }
        [lastTwoArray removeAllObjects];
        for (RemandModel *model in self.remandListArray) {
            //开始时间比今天早或者相等
            NSDate *beginModelDate=[datefomatter dateFromString:model.beginDate];
            NSDate *todayDate=[datefomatter dateFromString:nowDateStr];
            
            NSComparisonResult compatereuslt=[beginModelDate compare:todayDate];
            if (model.isOpen&&[model.isRepeat containsString:currentWekday]&&compatereuslt!=NSOrderedDescending) {
                
                NSInteger todayS=[[CommonHelper shareHeper]getMinitByTimeStr:nowtimeStr];
                NSInteger modelS=[[CommonHelper shareHeper]getMinitByTimeStr:model.excuteTime];
                
                if (modelS>todayS) {
                    //进行冒泡排序
                    if (lastTwoArray.count==0) {
                         [lastTwoArray addObject:model];
                    }
                    else{
                        //选择第一个和他比较
                        RemandModel *minmodel=lastTwoArray[0];
                        NSInteger modelones=[[CommonHelper shareHeper]getMinitByTimeStr:minmodel.excuteTime];
                        
                        if (lastTwoArray.count==1) {
                            if (modelS<modelones) {
                                [lastTwoArray insertObject:model atIndex:0];
                            }
                            else{
                                [lastTwoArray addObject:model];
                            }
                        }
                        else{
                            RemandModel *minmodel2=lastTwoArray[1];
                            NSInteger modelones2=[[CommonHelper shareHeper]getMinitByTimeStr:minmodel2.excuteTime];
                            
                            if (modelS<modelones) {
                                [lastTwoArray insertObject:model atIndex:0];
                            }
                            else if (modelS<modelones2){
                                 [lastTwoArray insertObject:model atIndex:1];
                            }
                            else{
                                [lastTwoArray addObject:model];
                            }
                        }
                    }
                   
                }
            }
        }
        
    }
}


#pragma mark-GFSelfInvolvedViewDelegate

-(void)anserQuestionClick{
    ProblemViewController *vc=[[ProblemViewController alloc]init];
    vc.titlesummary=@"自评问卷";
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)seeSoreTotal{
    
}

@end
