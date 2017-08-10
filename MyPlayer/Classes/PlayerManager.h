//
//  PlayerManager.h
//  BuldingMall
//
//  Created by Jion on 2017/8/8.
//  Copyright © 2017年 Youjuke. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol PlayerManagerDelegate <NSObject>
@optional
-(void)playerManagerTotalTime:(NSInteger)totalTime bufferTime:(NSInteger)bufferTime;
-(void)playerManagerCuttentTime:(NSInteger)cuttentTime;
-(void)playerManagerPlayerStatus:(AVPlayerItemStatus)itemStatus;
-(void)playerManagerDidFinish;
-(void)playerManagerDidFailed;

@end
@interface PlayerManager : NSObject

- (void)showInView:(UIView *)view;
@property(nonatomic,copy)NSString *movieUrl;
@property (nonatomic,weak)id<PlayerManagerDelegate>delegate;
//用于播放指定的时间段
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;
- (void)start;
- (void)pause;

@end
