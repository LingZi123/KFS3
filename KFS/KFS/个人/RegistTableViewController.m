//
//  RegistTableViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/18.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RegistTableViewController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "UserInfoModel.h"
#import "GFBase64.h"


@interface RegistTableViewController ()

@end

@implementation RegistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.title=@"注册";
    self.navigationItem.backBarButtonItem.title=@"返回";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self keyBoardDisapper];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (IBAction)getVerityCodeBtnClick:(id)sender {
    [self keyBoardDisapper];
    if (phoneField.text.length!=11) {
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"手机号无效";
        [hud hideAnimated:YES afterDelay:3.f];
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
    
    if([getVerityCodeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        //开始请求服务器

        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:phoneField.text,@"phone", nil];
        
        __weak typeof(self) weakself=self;
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        [manager POST:DE_UrlCodes parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
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
                //倒计时
                
                [hud hideAnimated:YES];
                timeCount=0;
                NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verityCodeTimerTick:) userInfo:nil repeats:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"网络错误";
            [hud hideAnimated:YES afterDelay:3.f];
            NSLog(@"%@",error);

        }];
    }
    else{
        return;
    }
    
}

-(void)verityCodeTimerTick:(NSTimer *)timer{
    if (timeCount==60) {
        getVerityCodeBtn.titleLabel.text=@"获取验证码";
        if (timer.isValid) {
            [timer invalidate];
            timer=nil;
        }
        return;
    }
    timeCount++;
    NSInteger lasttime=60-timeCount;
    [getVerityCodeBtn setTitle:[NSString stringWithFormat:@"%lD 秒",(long)lasttime] forState:UIControlStateNormal];
    
}

- (IBAction)registAndLoginBtnClick:(id)sender {
    [self keyBoardDisapper];
    NSString *phoneStr=[phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pwdStr=[pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *verityCodeStr=[vertyCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (phoneStr.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"手机号不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else if (pwdStr.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeText;

        hud.label.text=@"密码不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }

    else if (verityCodeStr.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeText;

        hud.label.text=@"验证码不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else{
        
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
        if (mynameFiled.text.length>0) {
            [mdic setObject:phoneField.text forKey:@"username"];
        }
        else{
            [mdic setObject:@"" forKey:@"username"];
        }
        
//        NSString *encodePwdStr=[GFBase64 encodeText:pwdStr];
        
        [mdic setObject:pwdStr forKey:@"password"];
        [mdic setObject:@"myname" forKey:@"trueName"];
        [mdic setObject:phoneStr forKey:@"phone"];
        [mdic setObject:verityCodeStr forKey:@"codes"];
       
        __weak  typeof(self) weakself=self;
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [manager POST:DE_UrlRegister parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
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
                //如果注册成功返回登陆界面
                //记录用户名密码
                
                [hud hideAnimated:YES];
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                if ([self appdelegate].userInfo==nil) {
                    [self appdelegate].userInfo=[[UserInfoModel alloc]init];
                }
                [self appdelegate].userInfo.username=phoneStr;
                [self appdelegate].userInfo.pwd=pwdStr;
                
                NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:[self appdelegate].userInfo];
                [defaults setObject:saveData forKey:DE_UserInfo];
                [defaults setObject:[self appdelegate].userInfo.username forKey:DE_Username];
                [defaults synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
    //            [[self appdelegate] makeMianView];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"网络错误";
             [hud hideAnimated:YES afterDelay:3.f];
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==phoneField) {
        [phoneField resignFirstResponder];
        [pwdField becomeFirstResponder];
    }
    else if (textField==pwdField){
        [pwdField resignFirstResponder];
        [vertyCodeField becomeFirstResponder];
    }
    else if (textField==vertyCodeField){
        [vertyCodeField resignFirstResponder];
        [mynameFiled becomeFirstResponder];
    }
    else{

//        [self registAndLoginBtnClick:nil];
    }
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField==phoneField) {
        [phoneField resignFirstResponder];
        [pwdField becomeFirstResponder];
    }
    else if (textField==pwdField){
        [pwdField resignFirstResponder];
        [vertyCodeField becomeFirstResponder];
    }
    else if (textField==vertyCodeField){
        [vertyCodeField resignFirstResponder];
        [mynameFiled becomeFirstResponder];
    }
    else{
//        [self registAndLoginBtnClick:nil];
    }
    return YES;
}

-(void)keyBoardDisapper{
    
    [phoneField resignFirstResponder];
    [pwdField resignFirstResponder];
    [vertyCodeField resignFirstResponder];
    [mynameFiled resignFirstResponder];

}
@end
