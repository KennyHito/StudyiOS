//
//  BaseViewController.m
//  iOSTest
//
//  Created by KennyHito on 2022/8/30.
//

#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (void)load{
    //    KLog(@"load ---> %s",__func__);
}

+ (void)initialize{
    //    KLog(@"initialize ---> %s",__func__);
}

- (void)pageActivityStart{
    KLog(@"调用了父类的pageActivityStart");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //让手机震动一下
//    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    KAddNotification(pageActivityStart, @"applicationWillEnterForeground");
    
    if(![self isKindOfClass:NSClassFromString(@"HomeViewController")]){
        KLog(@"我是 ----- %@",self.name);
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.navTitle){
        self.navigationItem.title = self.navTitle;
    }
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopHeight, KScreenW, KScreenH-KTopHeight-KSafeAreaHeight)];
    [self.view addSubview:self.bgView];
    
    /// 设置导航栏背景色的方法
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor]; //背景色
        appearance.shadowColor = UIColor.clearColor; //阴影
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark -- 获取顶部控制器
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
