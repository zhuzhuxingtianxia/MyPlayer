//
//  ImageDownLoadOperation.h
//  Round
//
//  Created by Jion on 2017/8/31.
//  Copyright © 2017年 天天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageDownLoadOperationDelegate
-(void)ImageDownLoadFinished:(UIImage*)image;
@end
@interface ImageDownLoadOperation : NSOperation

-(id)initOperationWithUrl:(NSURL*)imageUrl delegate:(id)delegate;

@end
