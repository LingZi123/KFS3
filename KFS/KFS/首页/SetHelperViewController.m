//
//  SetHelperViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "SetHelperViewController.h"
#import "AppDelegate.h"
#import "AddRemandViewController.h"

@interface SetHelperViewController ()

@end

@implementation SetHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title=@"助手设置";
    UIBarButtonItem *rigthBar=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem=rigthBar;
    tastTableview.tableFooterView=[[UIView alloc]init];
    tastTableview.rowHeight=96;
    dataMArray=[[NSMutableArray alloc]init];
    [dataMArray addObject:@"test1"];
    //注册cell
    [tastTableview registerNib:[UINib nibWithNibName:@"RemandSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"remandsetCell"];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark-添加任务
-(void)addTask:(UIBarButtonItem *)sender{
    
    AddRemandViewController *vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"AddRemandViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataMArray) {
        return  dataMArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indentif=@"remandsetCell";
    RemandSetTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentif];
    if (cell==nil) {
        cell=[[RemandSetTableViewCell alloc]init];
    }
    cell.myTitleLabel.text=[dataMArray objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:@"appLogo"];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"deletecell");
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED{
    return @"删除";
}

#pragma mark-AppDelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
