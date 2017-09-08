//
//  VideoListModel.h
//  MyPlayer
//
//  Created by Jion on 2017/9/8.
//  Copyright © 2017年 天天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VideoListModel : NSObject
@property(nonatomic,copy)NSString  *videoName;
@property(nonatomic,copy)NSString  *launchImg;
@property(nonatomic,copy)NSString  *videoUrl;
//播放状态 默认都是0
@property(nonatomic,copy)NSString  *playing;

-(instancetype)initWithDict:(NSDictionary*)dict;

+(void)getDataWithURL:(NSString *)url response:(void(^)(id json))result;

@end
