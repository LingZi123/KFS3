//
//  MoodUnitView.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodUnitView : UIView

@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)NSString *subImageName;
@property(nonatomic,assign)NSInteger btnCount;

-(instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count subimagename:(NSString *)subimagename;

@end
