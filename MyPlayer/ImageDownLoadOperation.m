//
//  ImageDownLoadOperation.m
//  Round
//
//  Created by Jion on 2017/8/31.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "ImageDownLoadOperation.h"

@implementation ImageDownLoadOperation
{
    NSURL *_imageUrl;
    id _delegate;
}
-(id)initOperationWithUrl:(NSURL*)imageUrl delegate:(id)delegate{
    if (self == [super init]) {
        _imageUrl = imageUrl;
        _delegate = delegate;
    }
    return self;
}
-(void)main{
    @autoreleasepool {
        UIImage *image = [self imageWithUrl:_imageUrl];
        if (_delegate && [_delegate respondsToSelector:@selector(ImageDownLoadFinished:)]) {
            [_delegate ImageDownLoadFinished:image];
        }
    }
}
-(UIImage*)imageWithUrl:(NSURL*)url{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
@end
