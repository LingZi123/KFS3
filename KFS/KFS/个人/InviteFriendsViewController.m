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
   
//    shareView=[[GFShareView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 300)];
//    shareView.delegate=self;
//     self.isHidenShareView=YES;
//    shareView.hidden= self.isHidenShareView;
//    
//    self.navigationItem.title=@"邀请好友";
//    [self.view addSubview:shareView];
    origiColor=self.view.backgroundColor;
    
//    [self getDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated{
//    [self addObserver:self forKeyPath:@"isHidenShareView" options:NSKeyValueObservingOptionNew  context:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self removeObserver:self forKeyPath:@"isHidenShareView"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.isHidenShareView) {
//        return;
//    }
//    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
//    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    UIView *currentView=[touch view];
//    if (![currentView isEqual:shareView]) {
//        self.isHidenShareView=YES;
//
//    }
}

- (IBAction)shareBtnClick:(id)sender {
    
//    self.isHidenShareView=NO;
    
}

- (IBAction)beginShare:(id)sender {
    
    UIButton *selecteBtn=(UIButton *)sender;
    //微信好友
    
    NSString *titlestr =@"发现了一个好用的APP";
    NSString *descriptionstr = @"点击下载，关注健康，关注生活";
    UIImage *img=[UIImage imageNamed:@"如愿康美60"];
    if (selecteBtn.tag==101) {
        
        WXWebpageObject *webpageObject=[WXWebpageObject object];
        webpageObject.webpageUrl=DE_ShareUrl;
        

        WXMediaMessage *message = [WXMediaMessage message];
        message.title =titlestr;
        message.description =descriptionstr;
        message.mediaObject = webpageObject;
        message.mediaTagName =@"如愿康美";
        [message setThumbImage:img];
        
        SendMessageToWXReq *req =[[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene=WXSceneSession;
        [WXApi sendReq:req];
        
    }
    else if (selecteBtn.tag==102){
        
        WXWebpageObject *webpageObject=[WXWebpageObject object];
        webpageObject.webpageUrl=DE_ShareUrl;
        
        WXMediaMessage *message=[WXMediaMessage message];
        message.title=titlestr;
        message.description=descriptionstr;
        [message setThumbImage:img];
        message.mediaObject=webpageObject;
        
        
        SendMessageToWXReq *req =[[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message=message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
        
    }
    else if (selecteBtn.tag==103){
        
        NSData *data=UIImagePNGRepresentation(img);
        
        QQApiNewsObject* obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:DE_ShareUrl ] title:titlestr description:descriptionstr previewImageData:data];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:obj];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];

    }
    else{
        
        
        QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:DE_ShareUrl] title:titlestr description:descriptionstr previewImageURL:nil];

        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
        
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        
        [self handleSendResult:sent];

        }

}

#pragma mark-观察者
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//    if ([keyPath isEqualToString:@"isHidenShareView"]) {
//       
//        if (!self.isHidenShareView) {
//            self.view.backgroundColor=[UIColor blackColor];
//            topView.alpha=0.8;
//        }
//
//        if (!self.isHidenShareView) {
//            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                shareView.hidden= self.isHidenShareView;
//                
//                //位置要加64的导航栏。否则会上移
//                shareView.frame=CGRectMake(0, CGRectGetHeight(self.view.frame)-300+64, CGRectGetWidth(self.view.frame), 300);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//        else{
//           
//            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                shareView.frame=CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 300);
//            } completion:^(BOOL finished) {
//                 shareView.hidden= self.isHidenShareView;
//                self.view.backgroundColor=origiColor;
//                topView.alpha=1;
//                
//            }];
//           
//            
//        }
//        
//    }
//    
//}

#pragma mark-GFShareViewDelegate
-(void)cancelShareView{
    self.isHidenShareView=YES;
}

#pragma mark-请求数据
//-(void)getDataFromServer{
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
//    [manager GET:DE_UrlInvite parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"网络错误");
//    }];
//}

//-(void)getDataFromLocal{
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    imageData=[defaults objectForKey:DE_UrlInvite];
//    if (imageData) {
//        shareImageview.image=[UIImage imageWithData:imageData];
//    }
//
//}
#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

#pragma mark-qq
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
    
    //    [self.delegate cancelShareView];
}


@end
