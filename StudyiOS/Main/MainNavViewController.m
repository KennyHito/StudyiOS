//
//  MainNavViewController.m
//  HitoTheme
//
//  Created by Apple on 2024/7/6.
//  Copyright © 2024年 KennyHito. All rights reserved.
//

#import "MainNavViewController.h"

@interface MainNavViewController ()

@end

@implementation MainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        UINavigationBar *navBar = [[UINavigationBar alloc] init];
        // 设置主题颜色
        navBar.tintColor = [UIColor blackColor];
        // 设置字体颜色
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
        navBar.titleTextAttributes = attributes;
        [self setValue:navBar forKey:@"navigationBar"];
    }
    return self;
}

#pragma mark - 设置状态栏白色
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


@end
