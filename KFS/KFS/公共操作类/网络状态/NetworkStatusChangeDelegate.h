//
//  NetworkStatusChangeDelegate.h
//  GBoxTV
//
//  Created by PC_201310113421 on 16/5/11.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol NetworkStatusChangeDelegate <NSObject>

-(void)networkStatusIsWifi;
-(void)networkStatusIsWan;
-(void)noNetworkStatus;//无网络

@end