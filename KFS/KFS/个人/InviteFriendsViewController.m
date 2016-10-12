//
//  InviteFriendsViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    shareView=[[GFShareView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 300)];
    shareView.delegate=self;
     self.isHidenShareView=YES;
    shareView.hidden= self.isHidenShareView;
    
    self.navigationItem.title=@"邀请好友";
    [self.view addSubview:shareView];
    origiColor=self.view.backgroundColor;
    
    [self getDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated{
    [self addObserver:self forKeyPath:@"isHidenShareView" options:NSKeyValueObservingOptionNew  context:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"isHidenShareView"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isHidenShareView) {
        return;
    }
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    UIView *currentView=[touch view];
    if (![currentView isEqual:shareView]) {
        self.isHidenShareView=YES;

    }
}

- (IBAction)shareBtnClick:(id)sender {
    
    self.isHidenShareView=NO;
    
}

#pragma mark-观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isHidenShareView"]) {
       
        if (!self.isHidenShareView) {
            self.view.backgroundColor=[UIColor blackColor];
            topView.alpha=0.8;
        }

        if (!self.isHidenShareView) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                shareView.hidden= self.isHidenShareView;
                
                //位置要加64的导航栏。否则会上移
                shareView.frame=CGRectMake(0, CGRectGetHeight(self.view.frame)-300+64, CGRectGetWidth(self.view.frame), 300);
            } completion:^(BOOL finished) {
                
            }];
        }
        else{
           
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                shareView.frame=CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 300);
            } completion:^(BOOL finished) {
                 shareView.hidden= self.isHidenShareView;
                self.view.backgroundColor=origiColor;
                topView.alpha=1;
                
            }];
           
            
        }
        
    }
    
}

#pragma mark-GFShareViewDelegate
-(void)cancelShareView{
    self.isHidenShareView=YES;
}

#pragma mark-请求数据
-(void)getDataFromServer{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    [manager GET:DE_UrlInvite parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        int a=0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络错误");
    }];
}

-(void)getDataFromLocal{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    imageData=[defaults objectForKey:DE_UrlInvite];
    if (imageData) {
        shareImageview.image=[UIImage imageWithData:imageData];
    }

}
#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
