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
        return;
    }
    
    if([getVerityCodeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        //开始请求服务器
        
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        [manager GET:DE_UrlCodes parameters:@"" progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        //并开始倒计时
    }
    else{
        return;
    }
    
}

- (IBAction)registAndLoginBtnClick:(id)sender {
    [self keyBoardDisapper];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DE_IsLogin];
    [defaults synchronize];
    [[self appdelegate] makeMianView];
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

        [self registAndLoginBtnClick:nil];
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
        [self registAndLoginBtnClick:nil];
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
