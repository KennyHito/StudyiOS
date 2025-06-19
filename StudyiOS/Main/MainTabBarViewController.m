//
//  MainTabBarViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/31.
//

#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"
#import "AboutViewController.h"

@interface MainTabBarViewController ()
<MainTabBarDelegate>

@end

@implementation MainTabBarViewController

- (instancetype)init{
    if (self = [super init]) {
        MainTabBar *tabBar = [[MainTabBar alloc]init];
        tabBar.subDelegate = self;
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
    NSArray *vcs = [VCControllers getVCController];
    NSDictionary *dic = [vcs lastObject];//使用最后一个
    
    BaseViewController *vc = [[NSClassFromString(dic[Tab_Url]) alloc] init];
    vc.navTitle = dic[Tab_Title];
    vc.MyBBLock = ^(NSString * _Nonnull des) {
        KLog(@"MyBBLock --- %@",des);
    };
    vc.hidesBottomBarWhenPushed = YES;
    [[[GetTopVCTool shareInstance] topViewController].navigationController pushViewController:vc animated:YES];
}

@end
