//
//  MyStateView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/8.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "MyStateView.h"
#import "JHChartHeader.h"

@implementation MyStateView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

-(void)makeView{
    
    UILabel *headlabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 21)];
    headlabel.font=DE_Font11;
    headlabel.text=@"我的状态";
    headlabel.textColor=DE_BgColorPink;
    [self addSubview:headlabel];
    
//    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(headlabel.frame), CGRectGetWidth(self.frame)-160, 85)];
//    [image setImage:[UIImage imageNamed:@"testimage"]];
//    [self addSubview:image];
    //画图
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(headlabel.frame)+8, CGRectGetWidth(self.frame)-40, 120) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.backgroundColor=[UIColor clearColor];
    
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    lineChart.xLineDataArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    /* 数据源 */
    lineChart.valueArr = @[@[@2,@1,@4,@6,@4,@9,@6],@[@10,@15,@3,@3,@6,@7,@9]];
    
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[DE_LineColorOrg, DE_LineColorPup];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[DE_BgColorPink,DE_BgColorPink];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = DE_BgColorPink;
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = DE_BgColorPink;
    
    /* 坐标点的虚线颜色 */
    lineChart.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    [self addSubview:lineChart];
    [lineChart showAnimation];


    UIButton *chakanBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, CGRectGetMaxY(lineChart.frame)+8, 60, 25)];
    [chakanBtn setTitle:@"查看历史" forState:UIControlStateNormal];
    chakanBtn.titleLabel.font=DE_Font11;
    [chakanBtn setBackgroundImage:[UIImage imageNamed:@"动态按钮"] forState:UIControlStateNormal];
    [chakanBtn setTitleColor:DE_BgColorPink forState:UIControlStateNormal];
    [self addSubview:chakanBtn];
    
    UIView *seg1=[[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-16, 1)];
    seg1.backgroundColor=DE_SegColorGray;
//    [self addSubview:seg1];
    
}

@end
