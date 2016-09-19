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

@interface LearnMainViewController ()

@end

@implementation LearnMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeTitleView];
    
    [mytableView registerNib:[UINib nibWithNibName:@"LearnSubCell" bundle:nil] forCellReuseIdentifier:@"learnSubCell"];
    [mytableView registerNib:[UINib nibWithNibName:@"LearnMainCell" bundle:nil] forCellReuseIdentifier:@"learnMainCell"];
    
    dataArray=[[NSMutableArray alloc]init];
    
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"learmimage1",@"imagename",@"  孙杨夺冠",@"maintitle",@"",@"detailtitle", nil];
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"learnimage2",@"imagename",@"测试1",@"maintitle",@"测试1detaile",@"detailtitle", nil];
     NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"learnimage3",@"imagename",@"测试2",@"maintitle",@"测试2detaile",@"detailtitle", nil];
    [dataArray addObject:dic1];
    [dataArray addObject:dic2];
    [dataArray addObject:dic3];
    
    mytableView.rowHeight=107;
    mytableView.tableFooterView=[[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeTitleView{
    UIScrollView *sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 260, 40)];
    sc.contentSize=CGSizeMake(200, 40);
    
    for (int i=0; i<3; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*(50+8), 7, 50, 26)];
        [btn setTitle:[NSString stringWithFormat:@"标题%D",i+1] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [sc addSubview:btn];
    }
    
    self.navigationItem.titleView=sc;
    UIBarButtonItem *searchBarItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick:)];
    self.navigationItem.rightBarButtonItem=searchBarItem;
    
    
}

#pragma mark-动作
-(void)searchBtnClick:(UIBarButtonItem *)sender{
    
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identif=@"learnSubCell";
    NSDictionary *data=[dataArray objectAtIndex:indexPath.row];
    
    if (indexPath.row==0) {
        identif=@"learnMainCell";
        LearnMainCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
        if (cell==nil) {
            cell=[[LearnMainCell alloc]init];
        }
        [cell.topImgeView setImage:[UIImage imageNamed:[data objectForKey:@"imagename"]]];
        cell.bottomTitleLabel.text=[data objectForKey:@"maintitle"];
        return cell;
        
    }
    else{
        LearnSubCell *cell=[tableView dequeueReusableCellWithIdentifier:identif];
        if (cell==nil) {
            cell=[[LearnSubCell alloc]init];
        }
        cell.rightImageView.image=[UIImage imageNamed:[data objectForKey:@"imagename"]];
        cell.mainLabel.text=[data objectForKey:@"maintitle"];
        cell.subLabel.text=[data objectForKey:@"detailtitle"];

        
        return cell;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray) {
        return  dataArray.count;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return DE_LearnTopviewRatio*CGRectGetWidth(self.view.frame);
    }
    return mytableView.rowHeight;
}

@end
