//
//  RemandSetTableViewCell.h
//  KFS
//
//  Created by PC_201310113421 on 16/8/10.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemandModel.h"

@interface RemandSetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel2;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
- (IBAction)switchValueChanged:(id)sender;
@property(nonatomic,retain)RemandModel *datamodel;
@end
