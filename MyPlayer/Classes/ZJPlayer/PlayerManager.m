//
//  PlayerManager.m
//  BuldingMall
//
//  Created by Jion on 2017/8/8.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager()
{
    AVPlayerLayer *playerLayer;
    NSURL  *videoUrl;
    id timeObserver;
    BOOL isPlaying;
    
}
//播放对象
@property(nonatomic,strong) AVPlayer *player;
//播放的视图
@property(nonatomic,weak)UIView  *supView;
@end
@implementation PlayerManager
static AVAudioSession *audioSession;
-(instancetype)init{
    self = [super init];
    if (self) {
        //设置系统静音模式下可以播放声音
        if (!audioSession) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            audioSession = session;
        }
        
    }
    return self;
}

#pragma mark -- Public Mothed

-(void)showInView:(UIView *)view{
    _supView = view;
    if (_movieUrl) {
        [self setUpObject];
    }
}

-(void)setMovieUrl:(NSString *)movieUrl{
    _movieUrl = movieUrl;
    if ([movieUrl hasPrefix:@"http"]) {
        videoUrl = [NSURL URLWithString:_movieUrl];
    }else{
        if ([movieUrl containsString:@"/"]) {
            videoUrl = [NSURL fileURLWithPath:movieUrl];
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:movieUrl ofType:nil];
            if (path) {
                videoUrl = [NSURL fileURLWithPath:path];
            }else{
                NSLog(@"找不到%@名字的文件",movieUrl);
            }
            
        }
        
    }
    
    if (_supView) {
        [self setUpObject];
    }
}

-(void)setUpObject{
    if (!self.player) {
        
        //使用playerItem获取视频的信息，当前播放时间，总时间等
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
        //player是视频播放的控制器，可以用来快进播放，暂停等
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self addObserver];
        //[self play];
    }
    
    playerLayer.frame = _supView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.supView.layer addSublayer:playerLayer];
    
}

-(void)setVolume:(float)volume{
    self.player.volume = volume;
    _volume = self.player.volume;
}

//是否需要静音
-(void)setMute:(BOOL)mute{
    self.player.muted = mute;
}

-(BOOL)isMute{
    
    return self.player.isMuted;
}

#pragma mark -- 添加监听

-(void)addObserver{
    //状态监听
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)([self class])];
    __weak typeof(self) weakSelf = self;
    timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
        //实时获取播放进度
        NSTimeInterval cuttentTime = CMTimeGetSeconds(time);
        if ([weakSelf.delegate respondsToSelector:@selector(playerManagerCuttentTime:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate playerManagerCuttentTime:cuttentTime];
            });
            
        }
        
    }];
    
    //监控网络加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)([self class])];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToPlayToEndTime:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
    //播放停止通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:self.player.currentItem];
    //可播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerShouldPlayNotification:) name:AVPlayerItemNewAccessLogEntryNotification object:self.player.currentItem];
    //播放出错通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayErrorNotification:) name:AVPlayerItemNewErrorLogEntryNotification object:self.player.currentItem];
    //进入后台和进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:)name:UIApplicationWillEnterForegroundNotification object:nil];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            
            [self playerStatus:object];
            
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
            [self playbackLoadedTimeRanges:object];
        }
    }
    
}

-(void)dealloc{
    
    [self.player pause];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewAccessLogEntryNotification object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemNewErrorLogEntryNotification object:self.player.currentItem];
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:(__bridge void * _Nullable)([self class])];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:(__bridge void * _Nullable)([self class])];
    
    [self.player removeTimeObserver:timeObserver];
    self.player = nil;
}
#pragma mark -- 监听播放变化
//播放完成
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    CMTime reCMTime = CMTimeMake(0, 1);
    [self.player seekToTime:reCMTime completionHandler:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(playerManagerDidFinish)]) {
        [self.delegate playerManagerDidFinish];
    }
}
-(void)playerPlaybackStalledNotification:(NSNotification *)notification{
    NSLog(@"停止");
    if ([self.delegate respondsToSelector:@selector(playerManagerShouldPlayLoad:)]) {
        [self.delegate playerManagerShouldPlayLoad:NO];
    }
}
-(void)playerShouldPlayNotification:(NSNotification *)notification{
    NSLog(@"可播放");
    if ([self.delegate respondsToSelector:@selector(playerManagerShouldPlayLoad:)]) {
        [self.delegate playerManagerShouldPlayLoad:YES];
    }
}
-(void)playerPlayErrorNotification:(NSNotification *)notification{
    NSLog(@"播放出错");
}
//播放失败的时间点
-(void)failedToPlayToEndTime:(NSNotification *)notification{
    NSLog(@"视频播放失败.");
    if ([self.delegate respondsToSelector:@selector(playerManagerDidFailed)]) {
        [self.delegate playerManagerDidFailed];
    }
}

-(void)applicationWillResignActive:(NSNotification *)notification{
    NSLog(@"进入后台");
    [self.player pause];
    
}
-(void)applicationWillEnterForeground:(NSNotification *)notification{
    NSLog(@"进入前台");
    if (isPlaying) {
        [self.player play];
    }
    
}
//播放状态
-(void)playerStatus:(AVPlayerItem*)playerItem{
    
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        NSLog(@"AVPlayerStatusReadyToPlay");
    }else if (playerItem.status == AVPlayerItemStatusFailed){
        NSLog(@"AVPlayerStatusFailed");
    }else{
        NSLog(@"AVPlayerStatusUnknown");
    }
    if ([self.delegate respondsToSelector:@selector(playerManagerPlayerStatus:)]) {
        [self.delegate playerManagerPlayerStatus:playerItem.status];
    }
}

-(void)playbackLoadedTimeRanges:(AVPlayerItem*)playerItem{
    //获取缓冲时间
    NSTimeInterval bufferTime = [self availableDuration:playerItem];
    //获取视频总时间
    NSTimeInterval durationTime = CMTimeGetSeconds(playerItem.duration);
    if ([self.delegate respondsToSelector:@selector(playerManagerTotalTime:bufferTime:)]) {
        [self.delegate playerManagerTotalTime:durationTime bufferTime:bufferTime];
    }
}

#pragma mark -- 开始/暂停方法
- (void)play {
    [self.player play];
    isPlaying = YES;
}

- (void)pause {
    [self.player pause];
    isPlaying = NO;
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler{
    CMTime reCMTime = CMTimeMake(time, 1);
    [self.player seekToTime:reCMTime completionHandler:^(BOOL finished) {
        completionHandler(finished);
    }];
}
//获取视频的缩略图
- (UIImage *)getImageVideo:(NSString *)videoURL{
    //截取1.0秒处的图片
   return  [self getImageVideo:videoURL seekToTime:1.0];
}

- (UIImage *)getImageVideo:(NSString *)videoURL seekToTime:(NSTimeInterval)ptime{
    UIImage *image = nil;
    @try {
        
        //根据URL获取AVURLAsset
        //AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
        
        //更具AVURLAsset 获取AVAssetImageGenerator
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.player.currentItem.asset];
        
        // 截图的时候调整到正确的方向
        gen.appliesPreferredTrackTransform = YES;
        
        //截取ptime时间点的图片，30 为每秒30帧
        CMTime cmtime = CMTimeMakeWithSeconds(ptime, 30);
        CGImageRef cgImage = [gen copyCGImageAtTime:cmtime actualTime:nil error:nil];
        
        image = [UIImage imageWithCGImage:cgImage];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return image;
}

#pragma mark - privte
- (NSTimeInterval)availableDuration:(AVPlayerItem*)playerItem {
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    if (loadedTimeRanges.count>0) {
        // 获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲总进度
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }else {
        return 0.0f;
    }
    
}

@end
