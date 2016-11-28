//
//  GFVideoViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/11/23.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFVideoViewController.h"

@interface GFVideoViewController ()

@end

@implementation GFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20, 44, 60, 30)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancelBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil
     ];
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
