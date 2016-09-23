//
//  RemandSetTableViewCell.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/10.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "RemandSetTableViewCell.h"
#import "RemandNotifManager.h"
@implementation RemandSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    
    if (_controlSwitch.isOn&&!self.datamodel.isOpen) {
        //打开
        NSLog(@"打开");
        NSMutableArray *array=[self.datamodel getRepeatArray:self.datamodel.isRepeat];
        NSString *str=[self.datamodel getRepeatDis:self.datamodel.isRepeat];
        [[RemandNotifManager shareManager]addLocalNotifWithModel:self.datamodel];
    }
    else if(!_controlSwitch.isOn&&self.datamodel.isOpen){
        //关闭
        NSLog(@"关闭");
        [[RemandNotifManager shareManager]deleteNotifWithModel:self.datamodel];
    }
}
@end
