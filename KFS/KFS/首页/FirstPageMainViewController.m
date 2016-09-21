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
    remandView=[[RemainView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(firstView.frame)+1, CGRectGetWidth(bgview.frame), 168)];
    remandView.delegate=self;
    [bgview addSubview:remandView];
    //我的状态
    
    mystateView=[[MyStateView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(remandView.frame)+1, CGRectGetWidth(bgview.frame), 200)];
    [bgview addSubview:mystateView];
    
    UIImageView *endImage=[[UIImageView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(mystateView.frame)+5, CGRectGetWidth(bgview.frame)-4, DE_Ration65*CGRectGetWidth(self.view.frame))];
    [endImage setImage:[UIImage imageNamed:@"任务"]];
    [bgview addSubview:endImage];
    
      bgview.contentSize=CGSizeMake(self.view.frame.size.width,firstView.frame.size.height+remandView.frame.size.height+mystateView.frame.size.height+endImage.frame.size.height+80);
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求健康和心情
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMyMoodAndHealth];
    }) ;
    
    //请求提醒
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMyRemand];
    }) ;
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

-(void)getMyRemand{
    
}
-(void)getMyStatus{
    
}
@end
