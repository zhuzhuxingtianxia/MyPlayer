//
//  VideoListModel.m
//  MyPlayer
//
//  Created by Jion on 2017/9/8.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "VideoListModel.h"
#import <objc/runtime.h>

@implementation VideoListModel

-(instancetype)initWithDict:(NSDictionary*)dict{
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        ///取出属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        NSString  *propertyString = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [dict valueForKey:propertyString];
        
        [self setValue:propertyValue forKey:propertyString];
        
    }
    
    return self;
}

+(void)getDataWithURL:(NSString *)url response:(void(^)(id json))result{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:nil];
        if (!path) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"没有找到模拟文件" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
            result(nil);
            return ;
        }
        NSData *data = [NSData dataWithContentsOfFile:path];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (data && json==nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Json格式错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
            
            result(nil);
            return;
        }
        result(json);
        
    });
    
}


@end
