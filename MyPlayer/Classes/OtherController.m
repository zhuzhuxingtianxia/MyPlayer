//
//  OtherController.m
//  MyPlayer
//
//  Created by Jion on 2017/8/10.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "OtherController.h"
#import "ImageDownLoadOperation.h"
@interface OtherController ()

@end

@implementation OtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"其他";
    
    [self buildView];
}
-(void)buildView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"自定义NSOperation" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(10, 10+64, button.frame.size.width+10, 40);
    [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark -- Action
-(void)gotoOperation{
    ImageDownLoadOperation *ysOper = [[ImageDownLoadOperation alloc] initOperationWithUrl:[NSURL URLWithString:@"https://m.youjuke.com/images/zt/zt_punish.jpg"] delegate:self];
    [ysOper start];
}

#pragma mark -- ImageDownLoadOperationDelegate

-(void)ImageDownLoadFinished:(UIImage *)image{
    NSLog(@"%@",image);
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
