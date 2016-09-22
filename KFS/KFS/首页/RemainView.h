//
//  RemainView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemandUnitView.h"

@protocol RemainViewDelegate <NSObject>

-(void)goSetHelperPage;

@end

@interface RemainView : UIView
{
    RemandUnitView *view1;
    RemandUnitView *view2;
}

@property(nonatomic,assign)id<RemainViewDelegate> delegate;
-(void)fullLastMyRemandWithArray:(NSArray *)array;//填充

@end
