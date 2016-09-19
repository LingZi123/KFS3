//
//  GFEditeMyTrideNameViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/9/9.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFEditeMyTrideNameViewController.h"

@interface GFEditeMyTrideNameViewController ()

@end

@implementation GFEditeMyTrideNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改群名称";
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick:)];
    self.navigationItem.rightBarButtonItem=rightbar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveClick:(UIBarButtonItem *)sender{
    if ([_name isEqualToString:tribeNameField.text]) {
        return;
    }
    if (tribeNameField.text.length<=0) {
        return;
    }
    [self.delegate modityMyTribeName:tribeNameField.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
