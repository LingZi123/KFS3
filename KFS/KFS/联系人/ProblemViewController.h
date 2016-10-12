//
//  ProblemViewController.h
//  KFS
//
//  Created by PC_201310113421 on 16/9/28.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWConversation.h>
#import <WXOpenIMSDKFMWK/YWMessageBodyCustomize.h>

@interface ProblemViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    UILabel *label;
    UITableView *dataTabelView;
    NSMutableArray *dataArray;
    
    BOOL isshowKeyboard;
    BOOL isInsertTabelview;
    CGRect originFrame;
}
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *titlesummary;

@property(nonatomic,retain)YWConversation *conversation;
@end
