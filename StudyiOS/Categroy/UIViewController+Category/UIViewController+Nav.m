//
//  UIViewController+Nav.m
//  StudyiOS
//
//  Created by Apple on 2025/6/9.
//

#import "UIViewController+Nav.h"

@implementation UIViewController (Nav)

- (void)setupCustomBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    // 创建自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(customBackAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 设置按钮大小
    [backButton setFrame:CGRectMake(0, 0, 30, 44)];
    [backButton setBackgroundColor:[UIColor redColor]];
    // 创建UIBarButtonItem
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 设置返回按钮
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    // 隐藏系统默认的返回按钮文字
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20; // 根据需要调整间距
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,backBarButtonItem];
}

- (void)customBackAction {
    // 自定义返回逻辑
    if ([self.navigationController popViewControllerAnimated:YES]) {
        // 执行默认返回操作
    } else {
        // 如果无法返回，则关闭当前视图控制器（如presentedViewController）
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
