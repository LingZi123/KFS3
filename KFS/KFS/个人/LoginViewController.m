//
//  LoginMainViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LableTextFieldView.h"
#import "RegistTableViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "ForgetPwdTableViewController.h"
#import "GFBase64.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:self.view.frame];
    [bgImage setImage:[UIImage imageNamed:@"登录背景"]];
    [self.view addSubview:bgImage];
    
    CGFloat width=CGRectGetWidth(self.view.frame);
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake( 0, 0, width, DE_LoginTopviewRatio*width)];
//    topView.backgroundColor=DE_BgColorPink;
    [self.view addSubview:topView];
    
//    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 165, 165)];
//    headImageView.center=topView.center;
//    [topView addSubview:headImageView];
    
    contentview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+20,width, 160)];
    contentview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:contentview];
    
    
    accountView=[[LableTextFieldView alloc]initWithFrame:CGRectMake(width*DE_Ration20, 23, width-2*width*DE_Ration20, 32)
                         ];
    accountView.titleLabel.text=@"帐号";
    accountView.textField.delegate=self;
    accountView.textField.placeholder=@"请输入账号";
    accountView.textField.returnKeyType=UIReturnKeyNext;
    [contentview addSubview:accountView];
    
    
    pwdView=[[LableTextFieldView alloc]initWithFrame:CGRectMake(width*DE_Ration20, CGRectGetMaxY(accountView.frame)+20, width-2*width*DE_Ration20, 32)
                 ];
    pwdView.titleLabel.text=@"密码";
    pwdView.textField.delegate=self;
    pwdView.textField.placeholder=@"请输入密码";
    pwdView.textField.secureTextEntry=YES;
    pwdView.textField.returnKeyType=UIReturnKeyGo;
    [contentview addSubview:pwdView];
    
    UIButton *loginbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    loginbtn.center=CGPointMake(contentview.center.x-55, CGRectGetMaxY(pwdView.frame)+45);
    [loginbtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    loginbtn.titleLabel.font=DE_Font14;
    loginbtn.titleLabel.textColor=[UIColor whiteColor];
    [loginbtn setBackgroundImage:[UIImage imageNamed:@"弹出框按钮"] forState:UIControlStateNormal];
    [contentview addSubview:loginbtn];
    
    
    UIButton *registbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
     registbtn.center=CGPointMake(contentview.center.x+55, CGRectGetMaxY(pwdView.frame)+45);
    [registbtn setBackgroundImage:[UIImage imageNamed:@"弹出框按钮空"] forState:UIControlStateNormal];
    [registbtn setTitle:@"注册" forState:UIControlStateNormal];
    registbtn.titleLabel.font=DE_Font14;
    [registbtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [registbtn addTarget:self action:@selector(regitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentview addSubview:registbtn];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(width-60-20, CGRectGetHeight(self.view.frame)-46, 60, 30)];
    [btn addTarget:self action:@selector(forgetPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    btn.titleLabel.font=DE_Font14;
    [btn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self.view addSubview:btn];
    originframe=self.view.frame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden=YES;
    self.username=[self appdelegate].userInfo.username;
    accountView.textField.text=self.username;
    
     self.pwd=[self appdelegate].userInfo.pwd;
    if (self.pwd) {
        pwdView.textField.text=[GFBase64 decodeText:self.pwd];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [accountView.textField resignFirstResponder];
    [pwdView.textField resignFirstResponder];
}
#pragma mark-UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==accountView.textField) {
        [accountView.textField resignFirstResponder];
        [pwdView.textField becomeFirstResponder];
    }
    else{
         [self loginBtnClick:nil];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect frame;
    if (textField==accountView.textField) {
        frame=accountView.frame;
    }
    else{
        frame=pwdView.frame;
    }
    
    int offset=contentview.frame.origin.y+CGRectGetMaxY(frame)-(originframe.size.height-216)+10;
    
    //被键盘挡住了
    if (offset>0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, -offset, originframe.size.width, originframe.size.height+offset);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.view.frame.origin.y<0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=originframe;
        } completion:^(BOOL finished) {
            [textField resignFirstResponder];
        }];
    }
}

- (IBAction)loginBtnClick:(id)sender {
    
    [accountView.textField resignFirstResponder];
    [pwdView.textField resignFirstResponder];
    
    NSString *accountStr=[accountView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pwdStr=[pwdView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (accountStr.length<=0||pwdStr.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text=@"用户名或密码为空了";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.0f];
        return;
    }
    
    //检查网络
    if ([self appdelegate].netstatus!=ReachableViaWiFi&&[self appdelegate].netstatus!=ReachableViaWWAN){
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text=@"无网络，请打开数据流量或等待wifi下使用";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.0f];

        return;
    }
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:accountStr forKey:@"username"];
    
    NSString *encodePwdStr=[GFBase64 encodeText:pwdStr];
    [mdic setObject:encodePwdStr forKey:@"password"];
    
    __weak typeof(self) weakSelf = self;

    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:DE_UrlLoginIn parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"error"]) {
            hud.mode=MBProgressHUDModeText;
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            
            [hud hideAnimated:YES];
            
            NSDictionary *data=[responseObject objectForKey:@"data"];
            
            NSString *token=[data objectForKey:@"token"];
            [weakSelf appdelegate].token=token;
            
            UserInfoModel *userModel=[UserInfoModel getModelWithDic:data];
            userModel.pwd=encodePwdStr;
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:DE_Token];
            
            if (![weakSelf.username isEqualToString:accountStr])
            {
                //清空头像
                [defaults setObject:nil forKey:DE_PhotoImage];
                weakSelf.username= accountStr;
                NSData *savedata=[NSKeyedArchiver archivedDataWithRootObject:userModel];
                [defaults setObject:savedata forKey:DE_UserInfo];
                
                [defaults setObject:userModel.username forKey:DE_Username];
            }
            
            [defaults synchronize];
            
            weakSelf.pwd=encodePwdStr;
            
            [weakSelf appdelegate].userInfo.username=userModel.username;
            [weakSelf appdelegate].userInfo.pwd=weakSelf.pwd;
            [weakSelf appdelegate].userInfo.headImage=userModel.headImage;
            [weakSelf appdelegate].userInfo.trueName=userModel.trueName;
            [weakSelf appdelegate].userInfo.phone=userModel.phone;
            
            [weakSelf appdelegate].userInfo.address=userModel.address;
            [weakSelf appdelegate].userInfo.age=userModel.age;
            [weakSelf appdelegate].userInfo.canLogin=userModel.canLogin;
            [weakSelf appdelegate].userInfo.canSpeak=userModel.canSpeak;
            [weakSelf appdelegate].userInfo.dontSpeakTime=userModel.dontSpeakTime;
            
            [weakSelf appdelegate].userInfo.height=userModel.height;
            [weakSelf appdelegate].userInfo.userId=userModel.userId;
            [weakSelf appdelegate].userInfo.isCheck=userModel.isCheck;
            [weakSelf appdelegate].userInfo.sex=userModel.sex;
            [weakSelf appdelegate].userInfo.weight=userModel.weight;
            
           
            [self loginIM];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
        
        NSLog(@"%@",error);
    }];
    
}


-(void)loginIM{
    
    //登录成功就登录im
    __weak typeof(self) weakSelf = self;
    [[SPUtil sharedInstance]setWaitingIndicatorShown:YES withKey:self.description];
    
    [[SPKitExample sharedInstance]callThisAfterISVAccountLoginSuccessWithYWLoginId:weakSelf.username passWord:weakSelf.pwd preloginedBlock:^{
        
        [[SPUtil sharedInstance]setWaitingIndicatorShown:NO withKey:weakSelf.description];
        
    } successBlock:^{
        
//        [[SPUtil sharedInstance]setWaitingIndicatorShown:NO withKey:weakSelf.description];

        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:DE_IsLogin];
        [defaults synchronize];
        
        [[self appdelegate]makeMianView];
        [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
        
    } failedBlock:^(NSError *aError) {
        [[SPUtil sharedInstance]setWaitingIndicatorShown:NO withKey:weakSelf.description];
        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"登录失败, 可以使用游客登录。\n（如在调试，请确认AppKey、帐号、密码是否正确。）" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"游客登录", nil];
                [as showInView:weakSelf.view];
            });
        }
        
    }
     ];

}
-(void)regitBtnClick:(UIButton *)sender{
    
    RegistTableViewController *vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"RegistTableViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)forgetPwdBtnClick:(UIButton *)sender{
    
    ForgetPwdTableViewController * vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"ForgetPwdTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
