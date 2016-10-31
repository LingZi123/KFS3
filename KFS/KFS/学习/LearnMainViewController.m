//
//  LearnMainViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "LearnMainViewController.h"
#import "LearnSubCell.h"
#import "LearnMainCell.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "AppDelegate.h"
#import "ReducationTypeModel.h"
#import "ReducationContentModel.h"

@interface LearnMainViewController ()

@end

@implementation LearnMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"学习";
//    [self makeTitleView];
    
    [mytableView registerNib:[UINib nibWithNibName:@"LearnSubCell" bundle:nil] forCellReuseIdentifier:@"learnSubCell"];
    [mytableView registerNib:[UINib nibWithNibName:@"LearnMainCell" bundle:nil] forCellReuseIdentifier:@"learnMainCell"];
    
    mytableView.rowHeight=107;
    mytableView.tableFooterView=[[UIView alloc]init];
    
     [self getTitleTypeFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeTitleView{
    if (sc==nil) {
        sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 260, 40)];
    }
    
    
    for (int i=0; i<_titlemArray.count; i++) {
        ReducationTypeModel *model=[_titlemArray objectAtIndex:i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*(50+8), 7, 50, 26)];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [sc addSubview:btn];
        
        if (i==0) {
            [self titleBtnClick:btn];
        }
    }
    
    if (_titlemArray.count*58>200) {
        sc.contentSize=CGSizeMake(_titlemArray.count*58, 40);
        sc.scrollEnabled=YES;

    }
    else{
        sc.contentSize=CGSizeMake(200, 40);

    }
       self.navigationItem.titleView=sc;
//    UIBarButtonItem *searchBarItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick:)];
//    self.navigationItem.rightBarButtonItem=searchBarItem;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
   
}
#pragma mark-动作
-(void)searchBtnClick:(UIBarButtonItem *)sender{
    
}

-(void)titleBtnClick:(UIButton *)sender{
    if ((oldSelectTitleBtn&&oldSelectTitleBtn.tag!=sender.tag)||oldSelectTitleBtn==nil) {
        sender.selected=YES;
        oldSelectTitleBtn.selected=NO;
        oldSelectTitleBtn=sender;
    }
    else{
        return;
    }
    ReducationTypeModel *model=[_titlemArray objectAtIndex:sender.tag-100];
    [self getRedutionInfoByTypeFromServer:model.modelId];
}
#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identif=@"learnSubCell";
    ReducationContentModel *data=[_contentArray objectAtIndex:indexPath.row];
    
    if (indexPath.row==0) {
        identif=@"learnMainCell";
        LearnMainCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
        if (cell==nil) {
            cell=[[LearnMainCell alloc]init];
        }
        if (data.pic==nil||data.pic==(id)[NSNull null]) {
             [cell.topImgeView setImage:[UIImage imageNamed:@"学习默认"]];
        }
        else{
            [cell.topImgeView setImage:[UIImage imageNamed:data.pic]];
        }
        
        cell.bottomTitleLabel.text=data.title;
        return cell;
        
    }
    else{
        LearnSubCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
        if (cell==nil) {
            cell=[[LearnSubCell alloc]init];
        }
        
        if (data.pic==nil||data.pic==(id)[NSNull null]) {
            [cell.rightImageView setImage:[UIImage imageNamed:@"学习默认"]];
        }
        else{
            [cell.rightImageView setImage:[UIImage imageNamed:data.pic]];
        }
        cell.mainLabel.text=data.title;
        cell.subLabel.text=data.content;
        return cell;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_contentArray) {
        return  _contentArray.count;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return DE_LearnTopviewRatio*CGRectGetWidth(self.view.frame);
    }
    return mytableView.rowHeight;
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
#pragma mark-网络交互
-(void)getTitleTypeFromServer{
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

    __weak typeof(self) weakself=self;
    
    [manager GET:DE_UrlDducation_Type parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        
        if ([status isEqualToString:@"error"]) {
            //从本地获取
            [weakself getTilteTypeFromLocal];
        }
        else{
            if (weakself.titlemArray==nil) {
                weakself.titlemArray=[[NSMutableArray alloc]init];
            }
            [weakself.titlemArray removeAllObjects];
            
            //保存
            NSArray *array=[responseObject objectForKey:@"data"];
            for (NSDictionary *dic  in array) {
                ReducationTypeModel *model=[ReducationTypeModel getModelWithDic:dic];
                [weakself.titlemArray addObject:model];
            }
            
            [weakself makeTitleView];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *data=[NSKeyedArchiver archivedDataWithRootObject:weakself.titlemArray];
            [defaults setObject:data forKey:DE_RedicationList];
            [defaults synchronize];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
        [weakself getTilteTypeFromLocal];
    }];
}
-(void)getTilteTypeFromLocal{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[defaults objectForKey:@"DE_RedicationList"];
    if (data) {
        NSMutableArray  *temparray=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (self.titlemArray==nil) {
            self.titlemArray=[[NSMutableArray alloc]init];
        }
        [self.titlemArray removeAllObjects];
        
        for (ReducationTypeModel *model in temparray) {
            [self.titlemArray addObject:model];
        }
    }
    
    [self makeTitleView];
}

-(void)getRedutionInfoByTypeFromServer:(NSString *)typeStr{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakself=self;
    [manager GET:[NSString stringWithFormat:@"%@?type=%@",DE_UrlDducationByType,typeStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            hud.label.text=[responseObject objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:3.f];
        }
        else{
            [hud hideAnimated:YES];
            if (weakself.contentArray==nil) {
                weakself.contentArray=[[NSMutableArray alloc]init];
            }
            [weakself.contentArray removeAllObjects];
            NSArray *tempArray=[responseObject objectForKey:@"data"];
            for (NSDictionary *dic in tempArray) {
                ReducationContentModel *model=[ReducationContentModel getModelWithDic:dic];
                [weakself.contentArray addObject:model];
            }
            
            [mytableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text=@"网络错误";
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}
@end
