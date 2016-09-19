//
//  GFShareView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/24.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@protocol GFShareViewDelegate <NSObject>

-(void)cancelShareView;

@end
@interface GFShareView : UIView<WXApiDelegate>{
    NSArray *titleArray;
}

@property(nonatomic,assign)id<GFShareViewDelegate>delegate;
@end
