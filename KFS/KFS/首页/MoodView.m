//
//  MoodView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MoodView.h"
#import "AFHTTPSessionManager.h"
#import "MoodAndHealthModel.h"
#import "AppDelegate.h"

@implementation MoodView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
        //获取位置
    UIImageView *locationImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 12.5, 19.5)];
    [locationImage setImage:[UIImage imageNamed:@"定位"]];
    [self addSubview:locationImage];
    
    UILabel *locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame)+10, 10, 200, 25)];
    locationLabel.font=DE_Font11;
    locationLabel.text=@"重庆市北部新区木星科技大厦";
    locationLabel.textColor=DE_BgColorPink;
    [self addSubview:locationLabel];
    
    xinqingview=[[MoodUnitView alloc]initWithFrame:CGRectMake(0, 0, 220, 26) count:5 subimagename:@""];
    xinqingview.titleLabel.text=@"心情：";
    xinqingview.delegate=self;
    xinqingview.center=CGPointMake(self.center.x, CGRectGetMaxY(locationLabel.frame)+32);
    [xinqingview.headImageView setImage:[UIImage imageNamed:@"心情2"]];
    [self addSubview:xinqingview];
    
    jiankangview=[[MoodUnitView alloc]initWithFrame:CGRectMake(0, 0,220, 26) count:5 subimagename:@""];
    [jiankangview.headImageView setImage:[UIImage imageNamed:@"健康2"]];
    jiankangview.titleLabel.text=@"健康：";
    jiankangview.delegate=self;
    jiankangview.center=CGPointMake(self.center.x, CGRectGetMaxY(xinqingview.frame)+24);
    [self addSubview:jiankangview];
    
    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, CGRectGetMaxY(jiankangview.frame)+10, 60, 25)];
    [chakanBtn setTitle:@"查看评分" forState:UIControlStateNormal];
    [chakanBtn addTarget:self action:@selector(seeGrade:) forControlEvents:UIControlEventTouchUpInside];
    [chakanBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
    chakanBtn.titleLabel.font=DE_Font11;
     [chakanBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:chakanBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 1)];
    seg1.backgroundColor=DE_SegColorGray;
    [self addSubview:seg1];

}

#pragma mark-动作事件

-(void)seeGrade:(UIButton *)sender{
    [self.delegate goGradePage];
}
-(void)jiankangBtnClick:(UIButton *)sender{
    
}

//获取心情和健康
-(void)getMoodAndHealth{
    
    //获取本地存储的心情和健康，包括用户名、心情、健康、时间
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *data=[defaults objectForKey:DE_Mood];
    _datamodel=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDate *today=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayStr=[formatter stringFromDate:today];
    
    if (_datamodel==nil) {
        _datamodel=[[MoodAndHealthModel alloc]init];
        _datamodel.mydate=todayStr;
        _datamodel.healthStarIndex=0;
        _datamodel.moodStarIndex=0;
        _datamodel.username=[self appdelegate].username;
        _datamodel.isPost=NO;
        
    }
    else{
        //不是今天重置
        if (![_datamodel.mydate isEqualToString:todayStr]) {
            _datamodel.mydate=todayStr;
            _datamodel.healthStarIndex=0;
            _datamodel.moodStarIndex=0;
            _datamodel.isPost=NO;
        }
    }
    
    [xinqingview fullStart:[_datamodel.moodStarIndex  integerValue] seleted:YES];
    [jiankangview fullStart:[_datamodel.healthStarIndex integerValue]seleted:YES];
    
}

#pragma mark-MoodUnitViewDelegate
-(void)moodUnitViewDidBtnSelected:(MoodUnitView *)view star:(NSString *)star{
    if (view==xinqingview) {
        _datamodel.moodStarIndex=star;
    }
    else{
        _datamodel.healthStarIndex=star;
    }
    
    if (xinqingview.selected&&jiankangview.selected&&!_datamodel.isPost) {
        //保存到服务器
        [self postToServer];
    }
}

#pragma mark-appdelegate
-(AppDelegate *)appdelegate{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)postToServer{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *mdic=[[NSMutableDictionary alloc]init];
    [mdic setObject: _datamodel.moodStarIndex forKey:@"mood"];
    [mdic setObject:_datamodel.healthStarIndex forKey:@"body_condition"];
    
    [manager.requestSerializer setValue:[self appdelegate].token forHTTPHeaderField:@"x-access-token"];
    __weak typeof(self)weakself=self;
    
    [manager POST:DE_UrlInfoByUser parameters:mdic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *status=[responseObject objectForKey:@"status"];
        if ([status isEqualToString:@"error"]) {
            
        }
        else{
            weakself.datamodel.isPost=YES;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *data=[NSKeyedArchiver archivedDataWithRootObject:weakself.datamodel];
            [defaults setObject:data forKey:DE_Mood];
            [defaults synchronize];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
