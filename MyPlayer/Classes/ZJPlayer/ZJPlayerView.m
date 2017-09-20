//
//  ZJPlayerView.m
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "ZJPlayerView.h"
#import "UIImage+Additions.h"

NSString * const ZJPlayBeforeOperationNotification = @"ZJPlayBeforeOperation_Notification_Name";

@interface ZJPlayerView ()<PlayerManagerDelegate>
{
    NSInteger _totalTime;
   __weak UIView  *originalView;//小屏时的父视图
    CGRect  originalRect;
}
@property(nonatomic,strong)PlayerManager *playerManager;
@property(nonatomic,strong)UIView *videoView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIImageView *placeholderImageView;
@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,strong)UILabel  *cuttentPlayTimeLabel;
@property(nonatomic,strong)UISlider *sliderView;
@property(nonatomic,strong)UILabel  *totalPlayTimeLabel;
@property(nonatomic,strong)UIButton *fullScreenBtn;
@property (strong, nonatomic)UIActivityIndicatorView *activityView;
@property(nonatomic,strong)UIButton  *reloadButton;
@end
@implementation ZJPlayerView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (self.fullScreenBtn.selected) {
        self.videoView.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }else{
     self.videoView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    [_playerManager showInView:self.videoView];
}

-(void)setUp{
    _playerManager = [[PlayerManager alloc] init];
    _playerManager.delegate = self;
    
    [self addSubview:self.videoView];
    [self addSubview:self.bottomView];
    [self addSubview:self.placeholderImageView];
    
    [self.bottomView addSubview:self.playBtn];
    [self.bottomView addSubview:self.cuttentPlayTimeLabel];
    [self.bottomView addSubview:self.sliderView];
    [self.bottomView addSubview:self.totalPlayTimeLabel];
    [self.bottomView addSubview:self.fullScreenBtn];
    
    [self addSubview:self.activityView];
    [self.activityView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBeforeOperation:) name:ZJPlayBeforeOperationNotification object:nil];
}

-(void)setMovieUrl:(NSString *)movieUrl{
    _movieUrl = movieUrl;
    _playerManager.movieUrl = movieUrl;
    
}

-(void)setPlaceholderImage:(NSString *)placeholderImage{
    if (!placeholderImage) return;
    _placeholderImage = placeholderImage;
    if ([_placeholderImage hasPrefix:@"http"]) {
#warning  这个方法会导致界面卡顿
      NSData *imgData =  [[NSUserDefaults standardUserDefaults] objectForKey:[_placeholderImage stringByAddingPercentEscapesUsingEncoding:NSUTF16StringEncoding]];
        if (!imgData) {
            imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_placeholderImage]];
            [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:[_placeholderImage stringByAddingPercentEscapesUsingEncoding:NSUTF16StringEncoding]];
        }
        self.placeholderImageView.image = [[UIImage imageWithData:imgData] blurredImage:0.5];
        
        /*
         //使用SDWebImage
        [self.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:_placeholderImage] placeholderImage:[[UIImage imageNamed:@"star@2x.jpg"] blurredImage:0.5] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.placeholderImageView.image = [image blurredImage:0.5];
        }];
        */
    }else{
      self.placeholderImageView.image = [[UIImage imageNamed:_placeholderImage] blurredImage:0.3];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.placeholderImageView.frame = self.bounds;
    
    if (self.fullScreenBtn.selected) {
        self.bottomView.frame = CGRectMake(0, self.frame.size.width - 40, self.frame.size.height, 40);
        self.activityView.center = CGPointMake(self.center.y, self.center.x);
        
    }else{
        
        self.activityView.center = self.center;
        self.bottomView.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
        
    }
    self.playBtn.frame = CGRectMake(0, 8, 40, 24);
    [self.cuttentPlayTimeLabel sizeToFit];
    self.cuttentPlayTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), 0, self.cuttentPlayTimeLabel.frame.size.width+10, 40);
    self.fullScreenBtn.frame = CGRectMake(self.bottomView.frame.size.width - 40, 9, 40, 22);
    [self.totalPlayTimeLabel sizeToFit];
    self.totalPlayTimeLabel.frame = CGRectMake(self.fullScreenBtn.frame.origin.x - self.totalPlayTimeLabel.frame.size.width - 5, 0, self.totalPlayTimeLabel.frame.size.width+10, 40);
    
    self.sliderView.frame = CGRectMake(CGRectGetMaxX(self.cuttentPlayTimeLabel.frame), 10, self.totalPlayTimeLabel.frame.origin.x - CGRectGetMaxX(self.cuttentPlayTimeLabel.frame), 20);
}

-(void)playBeforeOperation:(NSNotification*)fication{
    self.playBtn.selected = NO;
    [_playerManager pause];
    
}

#pragma mark -- Action
-(void)playVideoAction:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.0 animations:^{
            if (weakSelf.playBeforeOperation) {
                weakSelf.playBeforeOperation();
            }
            
        } completion:^(BOOL finished) {
            weakSelf.playBtn.selected = YES;
            [weakSelf.playerManager play];
            weakSelf.placeholderImageView.hidden = YES;
        }];
        
    }else{
       [_playerManager pause];
       
    }
}

-(void)reloadVideoAction:(UIButton*)senser{
    [_playerManager play];

}

-(void)screenChangeClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (!originalView) {
        originalView = self.superview;
        originalRect = self.frame;
    }
    if (sender.selected) {
        if (!self.cuttentController) {
            self.cuttentController = [self getCurrentVC];
        }
        if (self.cuttentController) {
            [self switchFullScreen:YES];
           
            if (self.cuttentController.navigationController) {
                [self.cuttentController.navigationController.view addSubview:self];
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = self.cuttentController.navigationController.view.bounds;
                } completion:^(BOOL finished) {
                    
                }];
            
            }else{
                
                [self.cuttentController.view addSubview:self];
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = self.cuttentController.view.bounds;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
        
    }else{
        
        [self switchFullScreen:NO];
        if (originalView) {
            [originalView addSubview:self];
            [UIView animateWithDuration:0.25 animations:^{
                self.frame = originalRect;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
}
-(void)changeMoiveProgress:(UISlider*)sender{
    NSTimeInterval timeInterval = _totalTime * sender.value;
    self.cuttentPlayTimeLabel.text = [self videoTimeWithTime:timeInterval];
    [self.activityView startAnimating];
    [_playerManager seekToTime:timeInterval completionHandler:^(BOOL finished) {
        if (finished) {
            [self.activityView stopAnimating];
        }
    }];
}

-(void)switchFullScreen:(BOOL)isFull{
    if (isFull) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            //在屏幕旋转的时候需要适配iOS8  重写hitTest方法
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [UIView animateWithDuration:0.25 animations:^{
            [self setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [UIView animateWithDuration:0.25 animations:^{
            [self setTransform:CGAffineTransformIdentity];
        }];
        
    }
}
#pragma mark --PlayerManagerDelegate
-(void)playerManagerTotalTime:(NSInteger)totalTime bufferTime:(NSInteger)bufferTime{
    _totalTime = totalTime;
    self.totalPlayTimeLabel.text = [self videoTimeWithTime:_totalTime];
}
-(void)playerManagerCuttentTime:(NSInteger)cuttentTime{
    self.cuttentPlayTimeLabel.text = [self videoTimeWithTime:cuttentTime];
    
    self.sliderView.value = floorl(cuttentTime)/_totalTime;
}
-(void)playerManagerPlayerStatus:(AVPlayerItemStatus)itemStatus{
    if (itemStatus == AVPlayerItemStatusReadyToPlay) {
        NSLog(@"AVPlayerStatusReadyToPlay");
        [UIView animateWithDuration:0.3 animations:^{
            [self.activityView stopAnimating];
            self.bottomView.hidden = NO;
            [self insertSubview:self.placeholderImageView belowSubview:self.bottomView];
        } completion:^(BOOL finished) {
            
        }];
    }else if (itemStatus == AVPlayerItemStatusFailed){
        NSLog(@"AVPlayerStatusFailed");
        [self playerManagerDidFailed];
    }else{
        NSLog(@"AVPlayerStatusUnknown");
        [self playerManagerDidFailed];
    }
}
-(void)playerManagerShouldPlayLoad:(BOOL)shouldPlay{
    if (shouldPlay) {
        [self.activityView stopAnimating];
    }else{
       [self.activityView startAnimating];
    }
}
//播放完成
-(void)playerManagerDidFinish{
    _totalPlayTimeLabel.text = @"00:00";
    self.sliderView.value = 0.0;
    _cuttentPlayTimeLabel.text = @"00:00";
    self.playBtn.selected = NO;
    self.placeholderImageView.hidden = NO;
    [self insertSubview:self.placeholderImageView belowSubview:self.bottomView];
}
//播放失败
-(void)playerManagerDidFailed{
     self.bottomView.hidden = YES;
    [self.activityView stopAnimating];
    self.placeholderImageView.image = [UIImage imageNamed:@"grzx_grbtb_png.png"];
    
    [self.reloadButton sizeToFit];
    self.reloadButton.center = self.placeholderImageView.center;
    [self.placeholderImageView addSubview:self.reloadButton];
}

-(NSString*)videoTimeWithTime:(NSTimeInterval)time{
    if (time>=0) {
        double minutes = floor(time / 60.0);
        double seconds = fmod(time, 60.0);
        if (minutes>=60) {
            double hours = floor(minutes / 60.0);
            minutes = fmod(minutes, 60.0);
            NSString *videoTime = [NSString stringWithFormat:@"%.0f:%02.0f:%02.0f",hours, minutes, seconds];
            return videoTime;
        }else{
            NSString *videoTime = [NSString stringWithFormat:@"%02.0f:%02.0f", minutes, seconds];
            return videoTime;
        }
        

    }
    return @"00:00";
}

#pragma mark -- getter
-(UIImageView*)placeholderImageView{
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.backgroundColor = [UIColor blackColor];
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}
-(UIView*)videoView{
    if (!_videoView) {
        _videoView = [[UIView alloc] init];
    }
    return _videoView;
}
-(UIView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

-(UIButton*)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"moviePlay"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"moviePause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playBtn;
}

-(UILabel*)cuttentPlayTimeLabel{
    if (!_cuttentPlayTimeLabel) {
        _cuttentPlayTimeLabel = [[UILabel alloc] init];
        _cuttentPlayTimeLabel.textColor = [UIColor whiteColor];
        _cuttentPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cuttentPlayTimeLabel.font = [UIFont boldSystemFontOfSize:10];
        _cuttentPlayTimeLabel.text = @"00:00";
    }
    return _cuttentPlayTimeLabel;
}
-(UISlider*)sliderView{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.continuous = YES;
        [_sliderView setThumbImage:[UIImage imageNamed:@"slider-default@2x"] forState:UIControlStateNormal];
        [_sliderView addTarget:self action:@selector(changeMoiveProgress:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}
-(UILabel*)totalPlayTimeLabel{
    if (!_totalPlayTimeLabel) {
        _totalPlayTimeLabel = [[UILabel alloc] init];
        _totalPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalPlayTimeLabel.textColor = [UIColor whiteColor];
        _totalPlayTimeLabel.font = [UIFont boldSystemFontOfSize:10];
        _totalPlayTimeLabel.text = @"00:00";
    }
    return _totalPlayTimeLabel;
}

-(UIButton*)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"movieFullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"movieEndFullscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(screenChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

-(UIActivityIndicatorView*)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.bounds = CGRectMake(0, 0, 80, 80);
        _activityView.hidesWhenStopped = YES;
        _activityView.backgroundColor = [UIColor blackColor];
        _activityView.alpha = 0.5;
        _activityView.layer.masksToBounds = YES;
        _activityView.layer.cornerRadius = 5.0;
    }
    return _activityView;
}
-(UIButton*)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_reloadButton setTitle:@"加载失败" forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZJPlayBeforeOperationNotification object:nil];

}

/**
 //对于iOS8.1 - iOS8.3版本使用
 [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
 导致部分点击区域不响应的解决办法。
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        BOOL isNeedAdaptiveiOS8 = [[self class] isNeedAdaptiveiOS8Rotation];
        
        UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
        //对于iOS8.1 - iOS8.3版本 当点击按钮位于home键的下半区域时不响应点击事件，因此只需要处理不响应的情况即可
        BOOL isNeedJudge = currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
        
        if (isNeedAdaptiveiOS8 && isNeedJudge) {
            CGPoint btnPoint = [self convertPoint:point toView:self.fullScreenBtn];
            if ([self.fullScreenBtn pointInside:btnPoint withEvent:event]) {
                //点击区域在clickBtn上
                __weak typeof(self) weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf screenChangeClick:self.fullScreenBtn];
                });
                weakSelf.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.userInteractionEnabled = YES;
                });
                return self.fullScreenBtn;
            }
        }

    }
    
    return [super hitTest:point withEvent:event];
}


+ (BOOL)isNeedAdaptiveiOS8Rotation{
    NSArray<NSString *> *versionStrArr = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    NSLog(@"versionArr is %@", versionStrArr);
    
    int firstVer = [[versionStrArr objectAtIndex:0] intValue];
    int secondVer = [[versionStrArr objectAtIndex:1] intValue];
    
    if (firstVer == 8) {
        if (secondVer >= 1 && secondVer <= 3) {
            return YES;
        }
    }
    
    return NO;
}


@end



