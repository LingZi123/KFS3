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
    [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.tableView.rowHeight=54;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    mainLabel.text=[self appdelegate].username;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
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
    if (indexPath.row==0) {
        return;
    }
    if (indexPath.row==1) {
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
    }
    else if (indexPath.row==2){
        //反馈
        [[SPKitExample sharedInstance] exampleOpenFeedbackViewController:NO fromViewController:self];
    }
    else{
        vc=[[self appdelegate].storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
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
#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    imageBtn.imageView.image=image;
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //            dispatch_async(kGlobalThread, ^{
        //
        //            DDLogVerbose(@"image size : %@", NSStringFromCGSize(image.size));
        
        //            dispatch_async(kMainThread, ^{
        //                self.completion(image);
        //            });
        //        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
//                        image= [image imageResizedToSize:CGSizeMake(100.0,100.0)];
            
            NSData *imageData=UIImagePNGRepresentation(image);
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            //            NSData *imagedata=NSData data
            [defaults setObject:imageData forKey:DE_PhotoImage];
            [defaults synchronize];
        });
        
        //
    }
    return;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        //取消选择
    }];
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
- (IBAction)imageBtnClick:(id)sender {
    //访问弹出框
    UIAlertController *cameravc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCamera=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=NO;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *fromPhotos=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=NO;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cameravc addAction:openCamera];
    [cameravc addAction:fromPhotos];
    [cameravc addAction:cancel];
    
    [self presentViewController:cameravc animated:YES completion:^{
        
    }];

}


@end
