//
//  ProblemViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ProblemViewController.h"
#import "ProblemFourTableViewCell.h"
#import "ProblemThreeTableViewCell.h"
#import "ProblemModel.h"

@interface ProblemViewController ()

@end

@implementation ProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    topView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:topView];
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(16, 30, 60, 30)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    
    UIButton *sendBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(topView.frame)-80, 30, 60, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sendBtn];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, CGRectGetWidth(topView.frame)-180, 30)];
    label.font=[UIFont systemFontOfSize:18];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [topView addSubview:label];
    
    dataTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(topView.frame))];
    dataTabelView.dataSource=self;
    dataTabelView.delegate=self;
//    dataTabelView.allowsMultipleSelection=YES;
    
    [self.view addSubview:dataTabelView];
    
    dataTabelView.tableFooterView=[[UIView alloc]init];
    

    [dataTabelView registerNib:[UINib nibWithNibName:@"ProblemFourTableViewCell" bundle:nil] forCellReuseIdentifier:@"valueTypeCell"];
    [dataTabelView registerNib:[UINib nibWithNibName:@"ProblemThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"RangeValueTypeCell"];
    
    originFrame=self.view.frame;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    label.text=self.titlesummary;
    if(dataArray==nil)
    {
        dataArray=[[NSMutableArray alloc]init];
    }
    [dataArray removeAllObjects];
    
    NSData *jsondata=[[NSData alloc]initWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *tempArray=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
    if (tempArray) {
        for (NSDictionary *dic in tempArray) {
            
            ProblemModel *model=[ProblemModel getModelWithDic:dic];
            [dataArray addObject:model];
        }
    }
    
    [dataTabelView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
-(void)send:(UIButton *)sender{
//    [self exampleSendCustomMessageWithConversation];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)exampleSendCustomMessageWithConversation{
    YWMessageBodyCustomize *body=[[YWMessageBodyCustomize alloc]initWithMessageCustomizeContent:@"你4不4 傻" summary:@"问卷答案"];
    [self.conversation asyncSendMessageBody:body progress:^(CGFloat progress, NSString *messageID) {
        
        
    } completion:^(NSError *error, NSString *messageID) {
        
        if (error.code==0) {
            NSLog(@"打招呼成功");
        }
        else{
            NSLog(@"打招呼失败");
        }
    }];
}

#pragma mark-UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ProblemModel *model=dataArray[section];
    
    if([model.valueType integerValue]==3){
        return 1;
    }
    else{
       
         NSArray *problemValueArray=model.problemValueArray;
        if (problemValueArray) {
            return problemValueArray.count;
        }
        else{
            return 0;
        }
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemModel *model=dataArray[indexPath.section];
    
    if([model.valueType integerValue]==4){
        return 60;
    }
    else{
        return 44;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ProblemModel *model=dataArray[section];
    return  [NSString stringWithFormat:@"%lD、%@?",(section+1),model.topic];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemModel *model=dataArray[indexPath.section];
    
     if ([model.valueType integerValue]==3){
        //范围
         NSString *indif=@"RangeValueTypeCell";
         ProblemThreeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indif];
        if (cell==nil) {
            cell=[[ProblemThreeTableViewCell alloc]init];
        }
        
        NSArray *problemValueArray=model.problemValueArray;
        NSDictionary *subdic1=[problemValueArray objectAtIndex:0];
        NSDictionary *subdic2=[problemValueArray objectAtIndex:1];

        NSInteger value1=[[subdic1 objectForKey:@"value"]integerValue];
        NSInteger value2=[[subdic2 objectForKey:@"value"]integerValue];
        if (value1<value2) {
            cell.decLabel.text=[NSString stringWithFormat:@"可选范围：%ld-%ld",(long)value1,(long)value2];
        }
        else{
             cell.decLabel.text=[NSString stringWithFormat:@"可选范围：%ld-%ld",(long)value2,(long)value1];
        }
        
        cell.textFiled.delegate=self;
        
        return cell;
    }
    else if([model.valueType integerValue]==4){
        //简答题
         NSString *indif=@"valueTypeCell";
          ProblemFourTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indif];
        if (cell==nil) {
            cell=[[ProblemFourTableViewCell alloc]init];
        }
        cell.textview.delegate=self;
        return cell;
    }
    else{
          //单选 多选
        NSString *indif=@"selectedValueTypeCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indif];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indif];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSArray *problemValueArray=model.problemValueArray;
        NSDictionary *subdic=[problemValueArray objectAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:@"单选灰"];
        cell.textLabel.text=[subdic objectForKey:@"value"];
        cell.textLabel.font=DE_Font14;
        
        cell.textLabel.textColor=[UIColor blackColor];
        
        return  cell;

    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProblemModel *model=dataArray[indexPath.section];
    
    //单选
    if ([model.valueType integerValue]==1) {
        NSArray *problemValueArray=model.problemValueArray;
        NSDictionary *subdic=[problemValueArray objectAtIndex:indexPath.row];
        NSString *valuetext=[subdic objectForKey:@"value"];
        
        NSString *values=model.value;
        
         UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        //选的同一个则取消选择
        if ([values containsString:valuetext]) {
            model.value=@"";
            cell.imageView.image=[UIImage imageNamed:@"单选灰"];
            return;
        }
        model.value=valuetext;
        cell.imageView.image=[UIImage imageNamed:@"单选亮"];
        //其他的为灰
        if (values.length>0) {
            for (int i=0; i<problemValueArray.count; i++) {
                NSString *deletevalustr=[[problemValueArray objectAtIndex:i] objectForKey:@"value"];
                if (i!=indexPath.row &&[deletevalustr isEqualToString:values]) {
                    NSIndexPath *delepath=[NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    UITableViewCell *deletecell=[tableView cellForRowAtIndexPath:delepath];
                    deletecell.imageView.image=[UIImage imageNamed:@"单选灰"];
                }
                
            }
        }
    }
    else if ([model.valueType integerValue]==2){
        NSArray *problemValueArray=model.problemValueArray;
        NSDictionary *subdic=[problemValueArray objectAtIndex:indexPath.row];
        NSString *valuetext=[subdic objectForKey:@"value"];
        
        NSString *values=model.value;
        
        //选的同一个则取消选择
        if ([values containsString:valuetext]) {
            NSString *newvalues=[values stringByReplacingOccurrencesOfString:valuetext withString:@" "];
            if ([newvalues containsString:@", ,"]) {
                newvalues=[newvalues stringByReplacingOccurrencesOfString:@", ," withString:@","];
            }
            model.value=newvalues;
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image=[UIImage imageNamed:@"单选灰"];
            return;
        }
        if (values.length==0) {
            model.value=valuetext;
        }
        else{
            model.value=[NSString stringWithFormat:@"%@,%@",values,valuetext];
        }
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image=[UIImage imageNamed:@"单选亮"];
    }

}
#pragma mark-UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *supview=textView.superview;
    while (![supview isKindOfClass:[UITableViewCell class]]) {
        supview=supview.superview;
    }
    UITableViewCell *cell=(UITableViewCell *)supview;
    [self changeKeyBoardPoisition:cell];
    return YES;
}

#pragma mark-UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyBoad];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIView *supview=textField.superview;
    while (![supview isKindOfClass:[UITableViewCell class]]) {
          supview=supview.superview;
    }
    UITableViewCell *cell=(UITableViewCell *)supview;
    [self changeKeyBoardPoisition:cell];
    return  YES;
}
#pragma  mark-UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark - 键盘处理

-(void)changeKeyBoardPoisition:(UITableViewCell *)cell{
    
    CGRect rect=[cell convertRect:cell.frame toView:self.view];
    
    if (rect.origin.y/2+rect.size.height>=originFrame.size.height-216) {
        isInsertTabelview=YES;
        dataTabelView.contentInset=UIEdgeInsetsMake(0, 0, 216+rect.size.height, 0);
        [dataTabelView scrollToRowAtIndexPath:[dataTabelView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }

}
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
//    //取出键盘最终的frame
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    //取出键盘弹出需要花费的时间
//    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //修改约束
//    //屏幕高度 - 键盘的Y值
//    self.bottomSpace.constant = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    isshowKeyboard=YES;
//    //取出键盘最终的frame
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    //取出键盘弹出需要花费的时间
//    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //修改约束
//    self.bottomSpace.constant = rect.size.height;
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    isshowKeyboard=NO;
//    //取出键盘弹出需要花费的时间
//    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //修改约束
//    self.bottomSpace.constant = 0;
//    [UIView animateWithDuration:duration animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeKeyBoad];
}

-(void)closeKeyBoad{
    //方式一
    if (isshowKeyboard) {
        [self.view endEditing:YES];
        
        if (isInsertTabelview) {
            //tableview移回来
            isInsertTabelview=NO;
            dataTabelView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
    }
}
@end
