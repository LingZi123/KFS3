//
//  RegisterViewController.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/3.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (IBAction)registerBtnClick:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DE_IsLogin];
    [defaults synchronize];
    [[self appdelegate] makeMianView];
    
}
-(AppDelegate *)appdelegate{
     return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
@end
