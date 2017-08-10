//
//  SingleController.m
//  MyPlayer
//
//  Created by Jion on 2017/8/10.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "SingleController.h"
#import "ZJPlayerView.h"
@interface SingleController ()

@end

@implementation SingleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
     ZJPlayerView *playerView = [[ZJPlayerView alloc] init];
     playerView.frame = CGRectMake(10, 10+64, [UIScreen mainScreen].bounds.size.width - 20, 180);
     playerView.backgroundColor = [UIColor blackColor];
     
     playerView.movieUrl = @"register_guide_video.mp4";//@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";//@"http://www.jxvdy.com/file/upload/201309/18/18-10-03-19-3.mp4";//
     playerView.cuttentController = self;
     [self.view addSubview:playerView];
     

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
