//
//  ForgetPwdTableViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/27.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ForgetPwdTableViewController.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface ForgetPwdTableViewController ()

@end

@implementation ForgetPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.title=@"密码重置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (IBAction)sendVerityCodeBtnClick:(id)sender {
    [self keyBoardDisapper];
    if (![self verityPhone]) {
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
    
    if([sendVerityCodeBtn.titleLabel.text isEqualToString:@"发送验证码"]) {
        //开始请求服务器
        
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:username,@"phone", nil];
        
        
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

- (IBAction)saveBtnClick:(id)sender {
    
    if (![self verityPhone]) {
        return;
    }
    if (![self verityPassword]) {
        return;
    }
    if (![self verityCodes]) {
        return;
    }
    
    [self postInfoToServer];
}

-(void)postInfoToServer{
    
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
    [mdic setObject:username forKey:@"username"];
    [mdic setObject:newpwd forKey:@"password"];
    [mdic setObject:codes forKey:@"codes"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:DE_UrlRecoverPassword parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.label.text=[responseObject objectForKey:@"messaget"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            [hud hideAnimated:YES];
            //修改密码
            
            [self appdelegate].userInfo.pwd=newpwd;
        
            //保存到本地
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *savedata=[NSKeyedArchiver archivedDataWithRootObject:[self appdelegate].userInfo];
            [defaults setObject:savedata forKey:DE_UserInfo];
            [defaults synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return  YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==phoneTextField) {
        if (![self verityPhone]) {
            return NO;
        }
        [newPwdTextField becomeFirstResponder];
    }
    else if (textField==newPwdTextField){
        return [self verityCodes];
    }
    else{
        [self verityCodes];
    }
    return YES;
}


-(void)verityCodeTimerTick:(NSTimer *)timer{
    if (timeCount==60) {
        sendVerityCodeBtn.titleLabel.text=@"发送验证码";
        if (timer.isValid) {
            [timer invalidate];
            timer=nil;
        }
        return;
    }
    timeCount++;
    NSInteger lasttime=60-timeCount;
    [sendVerityCodeBtn setTitle:[NSString stringWithFormat:@"%lD 秒",(long)lasttime] forState:UIControlStateNormal];
    
}
-(void)keyBoardDisapper{
    
    [phoneTextField resignFirstResponder];
    [newPwdTextField resignFirstResponder];
    [verityCodeField resignFirstResponder];
    
}


-(BOOL)verityPhone{
    
    BOOL result=YES;
    username=[phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [phoneTextField resignFirstResponder];
    if (username.length<=0||username.length!=11) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"手机号码不正确";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.f];
        result=NO;
    }

    return result;
}

-(BOOL)verityPassword{
    
    BOOL result=YES;
    newpwd=[newPwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [newPwdTextField resignFirstResponder];
    if (newpwd.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"密码长度不够";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.f];
        result=NO;
    }
    return result;

}
-(BOOL)verityCodes{
    
    BOOL result=YES;
    [verityCodeField resignFirstResponder];
    
    codes=[verityCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (codes.length<=0) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"验证码不对";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.f];
        result=NO ;
    }
    return result;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
