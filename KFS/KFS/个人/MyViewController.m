//
//  MyViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/12.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "SPKitExample.h"
#import "MyQuestionnaireTableViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.title=@"我的";
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *imagedata=[defaults objectForKey:DE_PhotoImage];
    UIImage *image=[UIImage imageWithData:imagedata];
    [headImageView setImage :image];
    self.tableView.rowHeight=54;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if ([self appdelegate].userInfo.trueName) {
        mainLabel.text=[self appdelegate].userInfo.trueName;
    }
    else{
        mainLabel.text=[self appdelegate].userInfo.username;
    }
    
    
    if ([self appdelegate].headImage) {
        [headImageView setImage:[self appdelegate].headImage];
    }
    else{
         [headImageView setImage :[UIImage imageNamed:@"头像90"] ];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 6;
    }
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc=nil;
    if (indexPath.section==1) {
        return;
    }
    if (indexPath.row==0) {
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"MyInfoTableViewController"];
    }
    else if (indexPath.row==1) {
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
    }
    else if (indexPath.row==2){
        //反馈
        [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:NO fromViewController:self];
    }
    else if(indexPath.row==3){
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    }
    else if(indexPath.row==4){
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"MyQuestionnaireTableViewController"];
    }
    else{
        [self actionClearCache];
        return;
    }
    
    
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
       return  DE_MyTopviewRatio*CGRectGetWidth(self.view.frame);
    }
    return self.tableView.rowHeight;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}


- (IBAction)logoutBtnClick:(id)sender {
    
    [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:DE_IsLogin];
    [defaults synchronize];
    [[self appdelegate] makeLoginView];
}

- (void)actionClearCache
{
    UIAlertController *vc=[UIAlertController alertControllerWithTitle:@"" message:@"确认要清除缓存数据吗" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[YWAPI sharedInstance] getGlobalUtilService4Cache] removeAllDatas];
        [self.tableView reloadData];
    }];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [vc addAction:ok];
    [vc addAction:cancel];
   
    [self presentViewController:vc animated:YES completion:^{
        
    }];

}


@end
