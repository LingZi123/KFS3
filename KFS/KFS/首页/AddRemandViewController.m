//
//  AddRemandViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "AddRemandViewController.h"
#import "GFDateView.h"
#import "LewPopupViewAnimationSpring.h"
#import "GFWeekView.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "RemandNotifManager.h"

@interface AddRemandViewController ()<GFDateViewDelegate,GFWeekViewDelegate>

@end

@implementation AddRemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"添加提醒";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [nameTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_remandmodel==nil) {
//        [nameTextField becomeFirstResponder];
        deleteBtn.hidden=YES;
        
        saveBtn.center=[saveBtn superview].center;
    }
    else{
        
        [self enbleItems:NO];
        //右边为编辑按钮
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBarClick:)];
        self.navigationItem.rightBarButtonItem=rightBar;
        
        deleteBtn.hidden=NO;
        //填充
        nameTextField.text=self.remandmodel.name;
        beginDateStr=self.remandmodel.beginDate;
        timeStr=self.remandmodel.excuteTime;
        name=self.remandmodel.name;
        repeatStr=self.remandmodel.isRepeat;
        
        [dateBtn setTitle:beginDateStr forState:UIControlStateNormal];
        [timeBtn setTitle:[timeStr substringWithRange:NSMakeRange(0, timeStr.length-3)] forState:UIControlStateNormal];

        [repeatBtn setTitle:[self.remandmodel getRepeatDis:self.remandmodel.isRepeat] forState:UIControlStateNormal];
        
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [nameTextField resignFirstResponder];
}
#pragma mark-动作
- (IBAction)dateBtnClick:(id)sender {
    [nameTextField resignFirstResponder];
    GFDateView *v=[GFDateView defaultPopupView:CGRectGetWidth(self.view.frame) datemode:UIDatePickerModeDate];
    v.titleLabel.text=@"添加日期";
    v.parentVC=self;
    v.delegate=self;
    [self lew_presentPopupView:v position:1  animation:[LewPopupViewAnimationSpring new] dismissed:^{
        
    }];
    
}

- (IBAction)timeBtnClick:(id)sender {
    [nameTextField resignFirstResponder];
    GFDateView *v=[GFDateView defaultPopupView:CGRectGetWidth(self.view.frame) datemode:UIDatePickerModeTime];
    v.titleLabel.text=@"添加时间";
    v.parentVC=self;
    v.delegate=self;
    [self lew_presentPopupView:v position:1  animation:[LewPopupViewAnimationSpring new] dismissed:^{
        
    }];
}

- (IBAction)repeatBtnClick:(id)sender {
    [nameTextField resignFirstResponder];
    GFWeekView *v=[GFWeekView defaultPopupView:CGRectGetWidth(self.view.frame)];
    v.parentVC=self;
    v.delegate=self;
    NSMutableArray *arry=nil;
    if (_remandmodel&&![_remandmodel.isRepeat isEqualToString:@"null"]) {
        arry=[_remandmodel getRepeatArray:_remandmodel.isRepeat];
    }
    [v fullWeekBtn:arry];
    [self lew_presentPopupView:v position:1  animation:[LewPopupViewAnimationSpring new] dismissed:^{
        
    }];
}


- (IBAction)changeBtnClick:(id)sender {
}

- (IBAction)saveBtnClick:(id)sender {
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    name= [nameTextField.text stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name<=0) {
        hud.label.text=@"名称不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else if (dateBtn.titleLabel.text.length<=0){
        hud.label.text=@"开始时间不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else if (timeBtn.titleLabel.text.length<=0){
        hud.label.text=@"执行时间不能为空";
        [hud hideAnimated:YES afterDelay:3.f];
    }
    else{
        [hud hideAnimated:YES];
    }
    
    if (self.remandmodel==nil) {
        //网络请求保存
        [self postToServer];
    }
    else{
        //修改
        [self putToServer];
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.remandmodel){
        //删除
        [self.delegate deleteRemand:self.remandmodel];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark-GFDateViewDelegate
-(void)didDateSelectedFinished:(NSString *)dateStr{
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
    beginDateStr=dateStr;
}
-(void)didTimeSelectedFinished:(NSString *)dateStr{
    [timeBtn setTitle:[dateStr substringWithRange:NSMakeRange(0, dateStr.length-3)] forState:UIControlStateNormal];
    timeStr=dateStr;
    
}
#pragma mrak-GFWeekViewDelegate
-(void)didWeekSelectedFinished:(NSString *)repeat weekStr:(NSString *)weekStr{
    [repeatBtn setTitle:weekStr forState:UIControlStateNormal];
     repeatStr=repeat;
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [nameTextField resignFirstResponder];
    return YES;
}





#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)postToServer{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:name forKey:@"name"];
    [mdic setObject:@"" forKey:@"pic"];
    
    NSString *postexecutiontime=[NSString stringWithFormat:@"%@#%@",beginDateStr,timeStr];
    [mdic setObject:postexecutiontime forKey:@"execution_time"];
    
    if (repeatStr==nil) {
        repeatStr=@"null";
    }
    [mdic setObject:repeatStr forKey:@"is_repeat"];
    [mdic setObject:[NSNumber numberWithBool:YES] forKey:@"is_open"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakself=self;
 
    [manager POST:DE_UrlRemind parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
            if (weakself.remandmodel==nil) {
                weakself.remandmodel=[[RemandModel alloc]init];
            }
            weakself.remandmodel.modelId=[[responseObject objectForKey:@"data"]integerValue];
            weakself.remandmodel.name=name;
            weakself.remandmodel.beginDate=beginDateStr;
            weakself.remandmodel.excuteTime=timeStr;
            weakself.remandmodel.isRepeat=repeatStr;
            weakself.remandmodel.isOpen=YES;
            
            
            [self.delegate addRemand:weakself.remandmodel];
            [[RemandNotifManager shareManager]addLocalNotifWithModel:weakself.remandmodel];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@",error);
        
    }];
    
}




//修改
-(void)putToServer{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:name forKey:@"name"];
    [mdic setObject:@"" forKey:@"pic"];
    
    NSString *postexecutiontime=[NSString stringWithFormat:@"%@#%@",beginDateStr,timeStr];
    [mdic setObject:postexecutiontime forKey:@"execution_time"];
    
    if (repeatStr==nil) {
        repeatStr=@"null";
    }
    [mdic setObject:repeatStr forKey:@"is_repeat"];
    [mdic setObject:[NSNumber numberWithBool:YES] forKey:@"is_open"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self)weakself=self;
    
    [manager PUT:[NSString stringWithFormat:@"%@/%ld",DE_UrlRemind,(long)self.remandmodel.modelId] parameters:mdic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.mode=MBProgressHUDModeText;
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            [hud hideAnimated:YES];
            
            // 先删除再修改
            [[RemandNotifManager shareManager]deleteNotifWithModel:weakself.remandmodel];
            
            weakself.remandmodel.name=name;
            weakself.remandmodel.beginDate=beginDateStr;
            weakself.remandmodel.excuteTime=timeStr;
            weakself.remandmodel.isRepeat=repeatStr;
            
            
            [self.delegate updateRemand:weakself.remandmodel];
            [[RemandNotifManager shareManager]addLocalNotifWithModel:weakself.remandmodel];
            [self.navigationController popViewControllerAnimated:YES];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode=MBProgressHUDModeText;
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
        NSLog(@"%@",error);
    }];
}


-(void)editBarClick:(UIBarButtonItem *)sender{
    [nameTextField becomeFirstResponder];
    [self enbleItems:YES];
}

-(void)enbleItems:(BOOL)enble{
    nameTextField.enabled=enble;
    dateBtn.enabled=enble;
    timeBtn.enabled=enble;
    repeatBtn.enabled=enble;
}
@end
