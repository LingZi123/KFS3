//
//  ProblemViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "ProblemViewController.h"

@interface ProblemViewController ()

@end

@implementation ProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    label=[[UILabel alloc]initWithFrame:CGRectMake(50, 200, 200, 300)];
    label.text=@"5555555555555555555";
    label.numberOfLines=0;
    [self.view addSubview:label];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 140, 60, 30)];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

-(void)viewWillAppear:(BOOL)animated{
    label.text=self.content;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
