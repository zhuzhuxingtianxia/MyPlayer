//
//  PlayerManager.h
//  BuldingMall
//
//  Created by Jion on 2017/8/8.
//  Copyright © 2017年 Youjuke. All rights reserved.
// 启动图，音量控制，手势交互等需要处理

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol PlayerManagerDelegate <NSObject>
@optional
/*
 @param totalTime 视频的总时间
 @param bufferTime 缓冲的时间进度
 */
-(void)playerManagerTotalTime:(NSInteger)totalTime bufferTime:(NSInteger)bufferTime;
/*
 @param 播放的当前时间
 */
-(void)playerManagerCuttentTime:(NSInteger)cuttentTime;
/*
 @param 播放状态回调
 */
-(void)playerManagerPlayerStatus:(AVPlayerItemStatus)itemStatus;
/*
 是否可播放的回调
 */
-(void)playerManagerShouldPlayLoad:(BOOL)shouldPlay;
/*
 播放完成的回调
 */
-(void)playerManagerDidFinish;
/*
   播放失败的回调
 */
-(void)playerManagerDidFailed;

@end
@interface PlayerManager : NSObject

//设置播放窗口
- (void)showInView:(UIView *)view;
//视频资源名称，路径，或链接
@property(nonatomic,copy)NSString *movieUrl;
//启动图,播放开始前显示的图片
@property (nonatomic, strong) UIImageView *launchView;
//定义代理
@property (nonatomic,weak)id<PlayerManagerDelegate>delegate;
/*
 用于定位到指定播放时间点
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;
/*
 开始播放
 */
- (void)play;
/*
 暂停播放器
 */
- (void)pause;

/**
 是否需要静音，默认值为NO
 */
@property (nonatomic, assign, getter=isMute) BOOL mute;
/**
 *  设置音量，范围是0-1.0，默认是1.0
 */
@property (nonatomic, assign)float volume;


@end
