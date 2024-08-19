//
//  MainTabBarViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/31.
//

#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "TableViewController.h"
#import "ChangeLogoViewController.h"
#import "CollectionViewController.h"
#import "AboutViewController.h"

@interface MainTabBarViewController ()<MainTabBarDelegate>

@end

@implementation MainTabBarViewController

- (instancetype)init{
    if (self = [super init]) {
        MainTabBar *tabBar = [[MainTabBar alloc]init];
        tabBar.delegate = self;
        [self setValue:tabBar forKeyPath:@"tabBar"];
        
        [self setUpChildViewControllers];
    }
    return self;
}

// 设置子控制器
- (void)setUpChildViewControllers {
    [self addChildViewController:[[HomeViewController alloc] init] image:@"tab_home_nor" seletedImage:@"tab_home_press" title:@"首页"];
    [self addChildViewController:[[TableViewController alloc] init] image:@"tab_classify_nor"  seletedImage:@"tab_classify_press" title:@"分类"];
    [self addChildViewController:[[CollectionViewController alloc] init] image:@"tab_community_nor"  seletedImage:@"tab_community_press" title:@"社区"];
    [self addChildViewController:[[AboutViewController alloc] init] image:@"tab_me_nor"  seletedImage:@"tab_me_press" title:@"我的"];
}

//添加子控制器
- (UIViewController *)addChildViewController:(UIViewController *)childController image:(NSString *)image seletedImage:(NSString *)selectedImage title:(NSString *)title {
    
    childController.title = title;
    
    // 设置图片
    [childController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    // 导航条
    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
    
    return childController;
}

#pragma mark -- MainTabBarDelegate
- (void)tabBarDidClickAddItem:(MainTabBar *)tabBar{
    NSLog(@"中间的按钮被点击了!");
    ChangeLogoViewController *vController = [[ChangeLogoViewController alloc] init];
    vController.hidesBottomBarWhenPushed = YES;
    [[self topViewController].navigationController pushViewController:vController animated:YES];
}

#pragma mark -- 下面两个方法用来获取当前最顶层的ViewController
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
