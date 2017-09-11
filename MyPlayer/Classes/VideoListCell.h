//
//  VideoListCell.h
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"
#import "ZJPlayerView.h"
@interface VideoListCell : UITableViewCell
@property(readonly)ZJPlayerView *playerView;
+(VideoListCell*)shareCell:(UITableView*)tableView model:(VideoListModel*)model comple:(void (^)())playBeforeBlock;
@end
