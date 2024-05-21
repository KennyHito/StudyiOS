//
//  MainTabBarViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/31.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpConfig];
}

- (void)setUpUI{
    UINavigationController * vc1 = [self createTabBarViewController:@"HomeViewController" withTitle:@"完了" withImageName:@"tab_1"];
    UINavigationController * vc2 = [self createTabBarViewController:@"TableViewController" withTitle:@"咋了" withImageName:@"tab_2"];
    UINavigationController * vc3 = [self createTabBarViewController:@"ReactiveObjCViewController" withTitle:@"崩了" withImageName:@"tab_3"];
    UINavigationController * vc4 = [self createTabBarViewController:@"CollectionViewController" withTitle:@"嘎了" withImageName:@"tab_4"];
    UINavigationController * vc5 = [self createTabBarViewController:@"AboutViewController" withTitle:@"快了" withImageName:@"tab_5"];
    self.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
}

- (UINavigationController *)createTabBarViewController:(NSString *)vc withTitle:(NSString *)title withImageName:(NSString *)imageStr{
    UIViewController *vController = [[NSClassFromString(vc) alloc] init];
    vController.title = title;
    vController.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vController];
    return nav;
}

- (void)setUpConfig{
    /// 设置tabbar背景色
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    /// 修改线条的颜色
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.shadowColor = [UIColor clearColor];
        appearance.backgroundColor = [UIColor whiteColor];
        [self.tabBar setStandardAppearance:appearance];
    }else{
        //去掉top线
        self.tabBar.shadowImage = [UIImage new];
        self.tabBar.backgroundImage = [UIImage new];
    }
    
    /// 改变tabbarController 文字选中颜色(默认渲染为蓝色)
    self.tabBar.tintColor = [UIColor redColor];
    if ([self.tabBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.tabBar.barTintColor = [UIColor whiteColor];
    }
}

@end
