//
//  GFShareView.m
//  KFS
//
//  Created by PC_201310113421 on 16/8/24.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import "GFShareView.h"




@implementation GFShareView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self makeView];

    }
    
    
    return self;
}


-(void)makeView{
    
    titleArray=[[NSArray alloc]initWithObjects:@"微信好友",@"微信朋友圈",@"QQ好友",@"QQ空间", nil];
    self.backgroundColor=DE_BgColorGray;
    self.alpha=0.9;
    //排版 微信好友、微信朋友圈、qq好友、qq空间  大小55px
    CGFloat widthFlex=(CGRectGetWidth(self.frame)-55*4)/5;
    CGFloat height=CGRectGetHeight(self.frame);
    for (int i=0; i<4; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(widthFlex+i*(55+widthFlex), 40, 55, 55)];
        btn.titleLabel.font=DE_Font11;
        [btn setBackgroundImage:[UIImage imageNamed:[titleArray  objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 21)];
        lbl.center=CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame)+20);
        lbl.text=[titleArray objectAtIndex:i];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=DE_Font11;
        [self addSubview:lbl];

    }
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,height-40-64,CGRectGetWidth(self.frame),40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor redColor]];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

}

-(void)shareBtnClick:(UIButton *)sender{
    //微信好友
    if (sender.tag==100) {
        SendMessageToWXReq *req =[[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.scene = WXSceneSession;
        if (req.bText)
            req.text = @"微信分享好友测试";
        else
            req.message = nil;
        [WXApi sendReq:req];

    }
    else if (sender.tag==101){
        SendMessageToWXReq *req =[[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.scene = WXSceneTimeline;
        if (req.bText)
            req.text = @"微信分享朋友圈测试";
        else
            req.message = nil;

        [WXApi sendReq:req];


    }
    else if (sender.tag==102){
        QQApiTextObject* txtObj = [QQApiTextObject objectWithText:@"qq文本分享测试"];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        [self handleSendResult:sent];
    }
    else{
        
        QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:@"分享到qq空间测试"];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        [self handleSendResult:sent];
    }
}

-(void)cancelBtnClick:(UIButton *)sender{
    [self.delegate cancelShareView];
}

//#pragma mark-WXApiManagerDelegate
//- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
//    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    alert.tag = 1000;
//    [alert show];
//}
//
//- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
//    WXMediaMessage *msg = req.message;
//    
//    //显示微信传过来的内容
//    WXAppExtendObject *obj = msg.mediaObject;
//    
//    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//}
//
//- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
//    WXMediaMessage *msg = req.message;
//    
//    //从微信启动App
//    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//}
//
//- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
//    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
////    [alert release];
//}
//
//- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
//    NSMutableString* cardStr = [[NSMutableString alloc] init];
//    for (WXCardItem* cardItem in response.cardAry) {
//        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp"
//                                                    message:cardStr
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
////    [alert release];
//}
//
//- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
//    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
////    [alert release];
//}

#pragma mark-qq
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
      
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
    
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
   
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
         
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
    
//    [self.delegate cancelShareView];
}


#pragma mark-apidelege
-(void)onReq:(BaseReq *)req{
    NSLog(@"%@",req);
}
-(void)onResp:(BaseResp *)resp{
    NSLog(@"%@",resp);
}
@end
