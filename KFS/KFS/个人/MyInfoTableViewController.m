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
#import "UserInfoModel.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWIndicator.h>
#import <WXOpenIMSDKFMWK/YWServiceDef.h>
#import "SPKitExample.h"

@interface MyInfoTableViewController ()

@end

@implementation MyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"个人信息";
    
    rightBar=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick:)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    originframe=self.view.frame;
    buttonEnble=YES;
    trueNameField.returnKeyType=UIReturnKeyDone;
    heightField.returnKeyType=UIReturnKeyNext;
    weightField.returnKeyType=UIReturnKeyDone;
    oldHeadImageUrl=[self appdelegate].userInfo.headImage;

    imageBtn.layer.masksToBounds=YES;
    imageBtn.layer.cornerRadius=CGRectGetWidth(imageBtn.frame)/2.f;
     [self enbleControls:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    //先去本地的图片
    if ([self appdelegate].headImage) {
        [imageBtn setBackgroundImage:[self appdelegate].headImage forState:UIControlStateNormal];
        if (![self appdelegate].userInfo.headImage||[self appdelegate].userInfo.headImage==(id)[NSNull null]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [self upLoadHeadImage:UIImagePNGRepresentation([self appdelegate].headImage)];
            });
        }

    }
    else{
        [imageBtn setBackgroundImage:[UIImage imageNamed:@"头像90"] forState:UIControlStateNormal];
    }
    
    usernameLabel.text=[self appdelegate].userInfo.username;
    
    NSString *sexstr=[self appdelegate].userInfo.sex;
    if (sexstr!=(id)[NSNull null]&& sexstr!=nil) {
        if ([sexstr isEqualToString:@"M"]||[sexstr isEqualToString:@"m"]) {
            
            [self sexBtnClick:sexNanBtn];
        }
        else{
            [self sexBtnClick:sexNvBtn];
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
    
    if ([self appdelegate].userInfo.trueName!=nil) {
        trueNameField.text=[self appdelegate].userInfo.trueName;
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
    return 4;
}

-(void)rightBarClick:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成"];
        //所有都可用
        [self enbleControls:YES];
    }
    else{
        //提交保存
        [self saveToServer];

    }
}
- (IBAction)imageBtnClick:(id)sender {
    //访问弹出框
    
    if (!buttonEnble) {
        return;
    }
    UIAlertController *cameravc=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *openCamera=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *fromPhotos=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
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
    if (!buttonEnble) {
        return;
    }
    UIButton *btn=(UIButton *)sender;
    
    if (oldSelectedBtn!=btn) {
        btn.selected=YES;
        if (oldSelectedBtn!=nil) {
            oldSelectedBtn.selected=NO;
            
        }
        oldSelectedBtn=btn;
//        if (oldSelectedBtn.selected&&!oldSelectedBtn.enabled) {
//            [oldSelectedBtn setImage:[UIImage imageNamed:@"单选亮"] forState:UIControlStateDisabled];
//        }
    }
    
}

-(void)enbleControls:(BOOL) enble{
    buttonEnble=enble;
    trueNameField.enabled=enble;
    //userNameTextField.enabled=enble;

//    sexNvBtn.enabled=enble;
//    sexNanBtn.enabled=enble;
    
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
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData=UIImagePNGRepresentation(image);
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            //            NSData *imagedata=NSData data
            [defaults setObject:imageData forKey:DE_PhotoImage];
            [defaults synchronize];
            
            [self appdelegate].headImage=image;
            [self upLoadHeadImage:imageData];
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
    [trueNameField resignFirstResponder];
    [weightField resignFirstResponder];
    [heightField resignFirstResponder];
    [_phoneField resignFirstResponder];
//    [userNameTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeKeyBoard];
}
#pragma mark- 保存到服务器

-(void)upLoadHeadImage:(NSData *)myimageData{
    
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:myimageData forKey:@"file"];
//
    
    //检查网络
    if ([self appdelegate].netstatus!=ReachableViaWiFi&&[self appdelegate].netstatus!=ReachableViaWWAN){
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text=@"无网络，请打开数据流量或等待wifi下使用";
        hud.mode=MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:3.0f];
        
        return;
    }
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    __weak typeof(self)weakself=self;
    
     __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text=@"正在上传头像";
        hud.mode=MBProgressHUDModeIndeterminate;
    });
    
    [manager POST:DE_UrlUpload parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        [formData appendPartWithFormData:myimageData name:@"file"];
        
        [formData appendPartWithFileData:myimageData name:@"file" fileName:@"png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if([status isEqualToString:@"error"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text=@"上传头像失败 ";
                hud.mode=MBProgressHUDModeText;
                
                [hud hideAnimated:YES afterDelay:2.f];
            });
            
            NSLog(@"上传头像失败 %@",[responseObject objectForKey:@"message"]);
        }
        else{
            //路径保存
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:0.f];
            });
            
            [weakself appdelegate].userInfo.headImage=[responseObject objectForKey:@"data"];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:[weakself appdelegate].userInfo];
            [defaults setObject:saveData forKey:DE_UserInfo];
            [defaults synchronize];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络错误，上传头像失败") ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.label.text=@"网络错误，上传头像失败";
            hud.mode=MBProgressHUDModeText;
            
            [hud hideAnimated:YES afterDelay:2.f];
        });
        
    }];
}

-(void)saveToServer{
   
    [self closeKeyBoard];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:[self appdelegate].userInfo.username forKey:@"username"];
    
    NSString *sexStr=[oldSelectedBtn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (oldSelectedBtn) {
        if (![[self appdelegate].userInfo.sex isEqualToString:sexStr]) {
            if ([oldSelectedBtn.titleLabel.text isEqualToString:@"男"]) {
                [dic setObject:@"M" forKey:@"sex"];

            }
            else if ([oldSelectedBtn.titleLabel.text isEqualToString:@"女"]){
                [dic setObject:@"F" forKey:@"sex"];
            }
        }
    }
    
    NSString *heightStr=[heightField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (heightStr.length>0&&![heightStr isEqual:[self appdelegate].userInfo.height]) {
        [dic setObject:heightStr forKey:@"height"];
    }
    
    NSString *weightStr=[weightField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (weightStr.length>0&&![weightStr isEqual:[self appdelegate].userInfo.weight]) {
        [dic setObject:weightStr forKey:@"weight"];
    }
    
    NSString *truenameStr=[trueNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (truenameStr.length>0&&![truenameStr isEqual:[self appdelegate].userInfo.trueName]) {
        [dic setObject:truenameStr forKey:@"trueName"];
    }
    
    if (![[self appdelegate].userInfo.headImage isEqualToString:oldHeadImageUrl]) {
        [dic setObject:[self appdelegate].userInfo.headImage forKey:@"headImage"];
    }
    
    if (dic.count==0) {
        
        //不做处理
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
            
            [rightBar setTitle:@"编辑"];
            //禁用所有
            [self enbleControls:NO];
            
            [hud hideAnimated:YES];
            [weakself appdelegate].userInfo.trueName=truenameStr;
            [weakself appdelegate].userInfo.height=heightStr;
            [weakself appdelegate].userInfo.weight=weightStr;
            [weakself appdelegate].userInfo.sex=sexStr ;
            
            oldHeadImageUrl=[self appdelegate].userInfo.headImage;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *saveData=[NSKeyedArchiver archivedDataWithRootObject:[weakself appdelegate].userInfo];
            [defaults setObject:saveData forKey:DE_UserInfo];
            [defaults synchronize];
            
            
            //移除缓存
            
            YWIMCore *imcore = [SPKitExample sharedInstance].ywIMKit.IMCore;
        YWPerson *mine=[[YWPerson alloc]initWithPersonId:[self appdelegate].userInfo.username inBaseContext:imcore];
            
            [[imcore getContactService]removeProfileForPerson:mine withSave:YES];
        

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}


#pragma mark-UITextFieldDelegate



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField==heightField){
        [weightField becomeFirstResponder];
    }
    
    return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSInteger row;
    if (textField==trueNameField) {
        row=2;
    }
    else if(textField==heightField){
        row=4;
    }
    else if (textField==weightField){
        row=5;
    }
    else{
        return;
    }
    int offset=row*90-(originframe.size.height-216);
    
    //被键盘挡住了
    if (offset>0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, -offset, originframe.size.width, originframe.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.view.frame.origin.y<0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, originframe.origin.y+64, originframe.size.width, originframe.size.height);
        } completion:^(BOOL finished) {
            [textField resignFirstResponder];
        }];
    }
}


@end
