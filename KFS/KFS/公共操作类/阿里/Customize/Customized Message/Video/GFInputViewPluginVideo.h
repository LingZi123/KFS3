//
//  GFInputViewPluginVideo.h
//  KFS
//
//  Created by PC_201310113421 on 16/11/23.
//  Copyright © 2016年 PC_201310113421. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

/// 输入面板的插件，需要遵循YWInputViewPluginProtocol协议

@interface GFInputViewPluginVideo : NSObject<YWInputViewPluginDelegate>

// 加载该插件的inputView
@property (nonatomic, weak) YWMessageInputView *inputViewRef;
@property (nonatomic, readonly) YWConversationViewController *conversationViewController;

@end
