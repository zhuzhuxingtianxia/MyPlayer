//
//  ZJPlayerView.h
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerManager.h"
//该通知可暂停播放同时修改播放按钮状态为暂停
FOUNDATION_EXPORT NSString * const ZJPlayBeforeOperationNotification;

typedef void(^PlayBeforeOperation)();
@interface ZJPlayerView : UIView
@property(readonly)PlayerManager *playerManager;
@property(nonatomic,weak)UIViewController *cuttentController;
@property(nonatomic,copy)NSString *movieUrl;
@property(nonatomic,copy)NSString *placeholderImage;
//点击播放前的操作
@property(nonatomic,copy)PlayBeforeOperation playBeforeOperation;
@end
