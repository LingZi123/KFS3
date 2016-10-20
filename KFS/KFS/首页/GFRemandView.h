//
//  GFRemandView.h
//  KFS
//
//  Created by PC_201310113421 on 16/10/20.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFRemandUnitView.h"

@protocol RemainViewDelegate <NSObject>

-(void)goSetHelperPage;

@end

@interface GFRemandView : UIView
{
    GFRemandUnitView *view1;
    GFRemandUnitView *view2;
}

@property(nonatomic,assign)id<RemainViewDelegate> delegate;
-(void)fullLastMyRemandWithArray:(NSArray *)array;//填充

@end
