//
//  MyInfoTableViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/10/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MyInfoTableViewController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

@interface MyInfoTableViewController ()

@end

@implementation MyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"个人信息";
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick:)];
    self.navigationItem.rightBarButtonItem=rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self enbleControls:NO];
    
    if (![self appdelegate].userInfo.headImage||[self appdelegate].userInfo.headImage==(id)[NSNull null]) {
        [imageBtn setBackgroundImage:[UIImage imageNamed:@"头像90"] forState:UIControlStateNormal];
    }
    else{
        [imageBtn setBackgroundImage:[UIImage imageNamed:[self appdelegate].userInfo.headImage] forState:UIControlStateNormal];
    }
    
    //userNameTextField.text=[self appdelegate].userInfo.username;
    
    NSString *sexstr=[self appdelegate].userInfo.sex;
    if (sexstr!=(id)[NSNull null]&& sexstr!=nil) {
        if ([sexstr isEqualToString:@"男"]) {
            sexNanBtn.selected=YES;
            oldSelectedBtn=sexNanBtn;
        }
        else{
            sexNvBtn.selected=YES;
            oldSelectedBtn=sexNvBtn;
        }
    }
    
    if ([self appdelegate].userInfo.height!=(id)[NSNull null]&& [self appdelegate].userInfo.height!=nil) {
         heightField.text=[self appdelegate].userInfo.height;
    }

    if ([self appdelegate].userInfo.weight!=(id)[NSNull null]&& [self appdelegate].userInfo.weight!=nil) {
         weightField.text=[self appdelegate].userInfo.weight;
    }

    if ([self appdelegate].userInfo.phone!=(id)[NSNull null]&&[self appdelegate].userInfo.phone!=nil) {
       _phoneField.text=[self appdelegate].userInfo.phone;
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 3;
}

-(void)rightBarClick:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成"];
        //所有都可用
        [self enbleControls:YES];
    }
    else{
        [sender setTitle:@"编辑"];
        //禁用所有
        [self enbleControls:NO];
        //提交保存
        [self saveToServer];
    }
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

- (IBAction)sexBtnClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if (oldSelectedBtn!=btn) {
        btn.selected=YES;
        if (oldSelectedBtn!=nil) {
            oldSelectedBtn.selected=NO;
            
        }
        oldSelectedBtn=btn;
    }
    
}

-(void)enbleControls:(BOOL) enble{
    imageBtn.enabled=enble;
    //userNameTextField.enabled=enble;

    sexNvBtn.enabled=enble;
    sexNanBtn.enabled=enble;
    heightField.enabled=enble;
    weightField.enabled=enble;
    _phoneField.enabled=enble;
    
    self.tableView.allowsSelection=enble;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
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


-(void)closeKeyBoard{
    [weightField resignFirstResponder];
    [heightField resignFirstResponder];
    [_phoneField resignFirstResponder];
  //  [userNameTextField resignFirstResponder];
}
#pragma mark- 保存到服务器

-(void)saveToServer{
   
    [self closeKeyBoard];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    if (oldSelectedBtn) {
        if (![[self appdelegate].userInfo.sex isEqualToString:oldSelectedBtn.titleLabel.text]) {
            [dic setObject:oldSelectedBtn.titleLabel.text forKey:@"sex"];
        }
    }
    
    NSString *heightStr=[heightField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (heightStr.length>0&&![heightStr isEqual:[self appdelegate].userInfo.height]) {
        [dic setObject:heightStr forKey:@"height"];
    }
    
    NSString *weightStr=[weightField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (weightStr.length>0&&![weightStr isEqual:[self appdelegate].userInfo.weight]) {
        [dic setObject:weightStr forKey:@"height"];
    }
    
    if (dic.count==0) {
        
        //不做处理
        return;
    }
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    __weak typeof(self)weakself=self;
    
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    [manager POST:DE_UrlUpgradeUser parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            
            [hud hideAnimated:YES];
            [weakself appdelegate].userInfo.height=heightStr;
            [weakself appdelegate].userInfo.weight=weightStr;
            [weakself appdelegate].userInfo.sex=oldSelectedBtn.titleLabel.text;
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:[weakself appdelegate].userInfo];
            [defaults setObject:saveData forKey:DE_UserInfo];
            [defaults synchronize];
            

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}


@end
