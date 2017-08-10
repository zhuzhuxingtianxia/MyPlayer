//
//  TabBarController.m
//  MyPlayer
//
//  Created by Jion on 2017/8/10.
//  Copyright © 2017年 天天. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self builfChildViewController];
}

//重写
- (BOOL)shouldAutorotate{
    BOOL autorotate = self.selectedViewController.shouldAutorotate;
    return autorotate;
    
}

-(void)builfChildViewController{
    NSArray *imageArray = @[@"sy_table_syicon_wxz@2x",@"sy_table_jgjicon_wxz@2x"];
    NSArray *imageSelectArray =@[@"sy_table_syicon_xz@2x",@"sy_table_jgiconj_xz@2x"];
   NSArray *titleArray = @[@"首页",@"其他"];
   NSArray *classNames = @[@"ViewController",@"OtherController"];
    for (int j=0;j<classNames.count;j++) {
        NSString *className = classNames[j];
        UIViewController *vc = [(UIViewController*)[NSClassFromString(className) alloc] init];
        
        vc.tabBarItem.image = [[UIImage imageNamed:imageArray[j]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelectArray[j]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.title = titleArray[j];
        
        //设置tabbar的title的颜色，字体大小，阴影
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName, nil];
        [vc.tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        NSShadow *shad = [[NSShadow alloc] init];
        shad.shadowColor = [UIColor whiteColor];
        
        NSDictionary *selectDic = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0/255.0 green:194/255.0 blue:79/255.0 alpha:1.0],NSForegroundColorAttributeName,shad,NSShadowAttributeName,[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil];
        [vc.tabBarItem setTitleTextAttributes:selectDic forState:UIControlStateSelected];
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:vc];
        
        [self addChildViewController:navi];
    }
    

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
