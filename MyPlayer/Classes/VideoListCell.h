//
//  VideoListCell.h
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListModel.h"

@interface VideoListCell : UITableViewCell

+(VideoListCell*)shareCell:(UITableView*)tableView model:(VideoListModel*)model;
@end
