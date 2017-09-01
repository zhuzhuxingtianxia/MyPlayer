//
//  UINavigationController+Autorotate.h
//  Owner
//
//  Created by Jion on 15/12/23.
//  Copyright © 2015年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Autorotate)
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
