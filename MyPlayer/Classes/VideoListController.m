//
//  VideoListController.m
//  BuldingMall
//
//  Created by Jion on 2017/8/7.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

#import "VideoListController.h"
#import "VideoListCell.h"

@interface VideoListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频列表";
    
    [self buildView];
    
    [self getLoadData];
}

-(void)buildView{
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

}

-(void)getLoadData{
    __weak typeof(self) weakSelf = self;
    [VideoListModel getDataWithURL:@"Video_List" response:^(id json) {
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *responeArray = (NSArray*)json;
            if (!weakSelf.dataArray) {
                weakSelf.dataArray = [NSMutableArray array];
            }
            for (NSDictionary *item in responeArray) {
                VideoListModel *videoModel = [[VideoListModel alloc] initWithDict:item];
                [weakSelf.dataArray addObject:videoModel];
            }
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListModel *model = self.dataArray[indexPath.row];
    VideoListCell *cell = [VideoListCell shareCell:tableView model:model];
    
    return cell;
}

- (BOOL)shouldAutorotate{
    return YES;
}

//支持横竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
