//
//  ViewController.m
//  MyPlayer
//
//  Created by Jion on 2017/8/10.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "ViewController.h"
#import "VideoListController.h"
#import "SingleController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    [self buildView];
}

-(void)buildView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"到单视频播放" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(10, 10+64, button.frame.size.width+10, 40);
    [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoSinglePlyer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitle:@"到列表视频播放" forState:UIControlStateNormal];
    [listButton sizeToFit];
    listButton.frame = CGRectMake(CGRectGetMaxX(button.frame)+20, 10+64, listButton.frame.size.width+10, 40);
    [listButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(gotoListButtonPlyer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listButton];
}

-(void)gotoSinglePlyer{
    SingleController *singleVideo = [[SingleController alloc] init];
    [self.navigationController pushViewController:singleVideo animated:YES];
}
-(void)gotoListButtonPlyer{
    VideoListController *videoList = [[VideoListController alloc] init];
    [self.navigationController pushViewController:videoList animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
