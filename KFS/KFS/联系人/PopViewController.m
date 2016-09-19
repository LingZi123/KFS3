//
//  PopViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/5.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    arr1=@[@"添加好友",@"发起群聊",@"搜索群组"];
    
    mytableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    mytableView.delegate=self;
    mytableView.dataSource=self;
    mytableView.scrollEnabled=YES;
    mytableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mytableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark-UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *indetif=@"popCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetif];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetif];
    }
    cell.textLabel.text=[arr1 objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.imageView.image=[UIImage imageNamed:[arr1 objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didCellSelected:indexPath.row viewController:self];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (arr1) {
        return arr1.count;
    }
    return 0;
}

-(CGSize)preferredContentSize{
    if (self.popoverPresentationController!=nil) {
        CGSize tempSize;
        tempSize.height=self.view.frame.size.height;
        tempSize.width=155;
        CGSize size=[mytableView sizeThatFits:tempSize];
        return  size;
    }
    else{
        return  [super preferredContentSize];
    }
}


@end
