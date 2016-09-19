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
    
    NSDate *today=[NSDate new];
    
//    if ([beginDate compare:today]) {
//        return;
//    }
//    
//    if (datamdic==nil) {
//        datamdic=[[NSMutableDictionary alloc]init];
//    }
    imagename=@"";
    [datamdic setObject:nameTextField.text forKey:@"name"];
    [datamdic setObject:imagename forKey:@"imageName"];
//    [datamdic setObject:beginDate forKey:@"beginDate"];
    [datamdic setObject:dateBtn.titleLabel.text forKey:@"beginDateStr"];
//    [datamdic setObject:beginTime forKey:@"beginTime"];
    [datamdic setObject:timeBtn.titleLabel.text forKey:@"beginTimeStr"];
    [datamdic setObject:repeatArray forKey:@"repeat"];
    [datamdic setObject:[NSNumber numberWithBool:YES] forKey:@"isOpen"];
    [datamdic setObject:@"医生" forKey:@"from"];
    
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *inputDateStr=[NSString stringWithFormat:@"%@ %@",beginDateStr,timeStr];
    NSDate* inputDate = [inputFormatter dateFromString:inputDateStr];
    
    NSInteger weekDay=[self getWeekDay:inputDate];
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
        NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",inputDateStr,repeatBtn.titleLabel.text] forKey:nameTextField.text];
        notification.userInfo = infoDict; //添加额外的信息

        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else if ([repeatBtn.titleLabel.text isEqualToString:@"工作日"]){
        
            for (int i=1; i<6; i++) {
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:nameTextField.text];
            //
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }
    }
    else if ([repeatBtn.titleLabel.text isEqualToString:@"周末"]){
        
        for (int i=6; i<8; i++) {
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:nameTextField.text];
            //
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }
    }
    else{
        
        
        for (int i=1; i<8; i++) {
            
            NSString *item =repeatArray[i-1];
            if ([item isEqualToString:@"0"]) {
                continue;
            }
            NSDictionary*infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ 周%D",inputDateStr,i] forKey:nameTextField.text];
            [self exeAddNotifWeekDay:i curentWeekDay:weekDay notification:notification inputDate:inputDate info:infoDict];
        }

    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)deleteBtnClick:(id)sender {
}

#pragma mark-GFDateViewDelegate
-(void)didDateSelectedFinished:(NSString *)dateStr{
    [dateBtn setTitle:dateStr forState:UIControlStateNormal];
    beginDateStr=dateStr;
}
-(void)didTimeSelectedFinished:(NSString *)dateStr{
    [timeBtn setTitle:dateStr forState:UIControlStateNormal];
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

-(NSInteger)getWeekDay:(NSDate *)date{
    NSArray *weekdays = [NSArray arrayWithObjects: @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [[weekdays objectAtIndex:theComponents.weekday] integerValue];
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
@end
