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
        [nameTextField becomeFirstResponder];

    }
    else{
        
        [self enbleItems:NO];
        //右边为编辑按钮
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBarClick:)];
        self.navigationItem.rightBarButtonItem=rightBar;
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
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
    [self lew_presentPopupView:v position:1  animation:[LewPopupViewAnimationSpring new] dismissed:^{
        
    }];
}


- (IBAction)changeBtnClick:(id)sender {
}

- (IBAction)saveBtnClick:(id)sender {
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (nameTextField.text.length<=0) {
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
-(void)didWeekSelectedFinished:(NSMutableArray *)array weekStr:(NSString *)weekStr{
    [repeatBtn setTitle:weekStr forState:UIControlStateNormal];
    if (repeatArray==nil) {
        repeatArray=[[NSMutableArray alloc]init];
    }
    [repeatArray removeAllObjects];
    [repeatArray addObjectsFromArray:array];
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [nameTextField resignFirstResponder];
    return YES;
}



-(void)exeAddNotifWeekDay:(NSInteger )weekday  curentWeekDay:(NSInteger )currentWeekDay notification:(UILocalNotification *)notification inputDate:(NSDate *)inputDate info:(NSDictionary *)info{
    
    NSInteger a=weekday-currentWeekDay;
    if (a<0) {
        a+=7;
    }
    notification.fireDate=[inputDate dateByAddingTimeInterval:a*60*60*24];
    notification.repeatInterval=NSCalendarUnitWeekday;//循环次数，kCFCalendarUnitWeekday一周一次
    notification.userInfo=info;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)postToServer{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject:nameTextField.text forKey:@"name"];
    [mdic setObject:@"" forKey:@"pic"];
    
    NSString *postexecutiontime=[NSString stringWithFormat:@"%@#%@",beginDateStr,timeStr];
    [mdic setObject:postexecutiontime forKey:@"execution_time"];
    
    if (repeatArray) {
        for (int i=0; i<repeatArray.count; i++) {
            if ([[repeatArray objectAtIndex:i] isEqualToString:@"1"]) {
                if (repeatStr.length>0) {
                    repeatStr=[NSString stringWithFormat:@"%@%D#",repeatStr,i+1];
                }
                else{
                    repeatStr=[NSString stringWithFormat:@"%D#",i+1];
                }
            }
            
        }
    }
    else{
        repeatStr=@"null";
    }
    repeatStr=[repeatStr substringWithRange:NSMakeRange(0, repeatStr.length-1)];
    
    [mdic setObject:repeatStr forKey:@"is_repeat"];
    [mdic setObject:[NSNumber numberWithBool:YES] forKey:@"is_open"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
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
            if (_remandmodel==nil) {
                _remandmodel=[[RemandModel alloc]init];
            }
            _remandmodel.modelId=[[responseObject objectForKey:@"data"]integerValue];
            _remandmodel.name=nameTextField.text;
            _remandmodel.beginDate=beginDateStr;
            _remandmodel.excuteTime=timeStr;
            _remandmodel.isRepeat=repeatStr;
            _remandmodel.isOpen=YES;
            
            //存到系统
            [self.delegate addRemand:_remandmodel];
            [self addLocalNotif];
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
    
}

-(void)addLocalNotif{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *inputDateStr=[NSString stringWithFormat:@"%@ %@",beginDateStr,timeStr];
    NSDate* inputDate = [inputFormatter dateFromString:inputDateStr];
    
    NSInteger weekDay=[[CommonHelper shareHeper] getWeekDay:inputDate];
    NSLog(@"%@",inputDate);
    
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"短信08" ofType:@"caf"];
    NSLog(@"path-------------%@",path);
    notification.soundName=@"故事03.m4a";
    notification.applicationIconBadgeNumber++;//应用的红色数字
    
    //去掉下面2行就不会弹出提示框
    notification.alertTitle=@"任务通知";
    notification.alertBody=nameTextField.text;//提示信息 弹出提示框
    notification.alertAction = @"打开";  //提示框按钮
    notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
    
    // 添加通知
    if (repeatArray.count==7) {
        notification.fireDate=inputDate;
        notification.repeatInterval=NSCalendarUnitDay;//循环次数，kCFCalendarUnitWeekday一天一次
        NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",inputDateStr,repeatBtn.titleLabel.text] forKey:_remandmodel.name];
        notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else if ([repeatBtn.titleLabel.text isEqualToString:@"工作日"]){
        
        for (int i=1; i<6; i++) {
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:_remandmodel.name];
            
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }
    }
    else if ([repeatBtn.titleLabel.text isEqualToString:@"周末"]){
        
        for (int i=6; i<8; i++) {
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:_remandmodel.name];
            
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }
    }
    else{
        
        
        for (int i=1; i<8; i++) {
            
            NSString *item =repeatArray[i-1];
            if ([item isEqualToString:@"0"]) {
                continue;
            }
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:_remandmodel.name];
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }
        
    }

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
