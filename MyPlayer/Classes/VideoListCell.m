//
//  VideoListCell.m
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "VideoListCell.h"
#import "ZJPlayerView.h"

@interface VideoListCell ()
@property(nonatomic,strong)ZJPlayerView *playerView;
@property(nonatomic,strong)id  model;
@end
@implementation VideoListCell

+(VideoListCell*)shareCell:(UITableView*)tableView model:(id)model{
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = model;
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.playerView.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 180);
        [self.contentView addSubview:self.playerView];
    }
    return self;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setModel:(id)model{
    _model = model;
    NSInteger pp = arc4random()%10;
    if (pp%3 == 1) {
         self.playerView.movieUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    }else if (pp%3 == 2){
        self.playerView.movieUrl = @"register_guide_video.mp4";
    }
   
}

#pragma mark -- getter
-(ZJPlayerView*)playerView{
    if (!_playerView) {
        _playerView = [[ZJPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
