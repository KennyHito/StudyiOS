//
//  AppDelegate.m
//  StudyiOS
//
//  Created by Apple on 2022/10/31.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
#pragma mark -->NSLog(@"\n ===> 程序挂起 !");  比如:当有电话进来或者锁屏，这时你的应用程会挂起，在这时，UIApplicationDelegate委托会收到通知，调用 applicationWillResignActive 方法，你可以重写这个方法，做挂起前的工作，比如关闭网络，保存数据。
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
#pragma mark --> NSLog(@"\n ===> 程序进入后台 !");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
#pragma mark --> NSLog(@"\n ===> 程序进入前台 !");
    //清除通知角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //业务一些操作
    KSendNotification(@"applicationWillEnterForeground",nil);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#pragma mark -->  NSLog(@"\n ===> 程序重新激活 !"); 应用程序在启动时，在调用了 applicationDidFinishLaunching 方法之后也会调用 applicationDidBecomeActive 方法，所以你要确保你的代码能够分清复原与启动，避免出现逻辑上的bug。(大白话就是说:只要启动app就会走此方法)。
}

- (void)applicationWillTerminate:(UIApplication *)application {
#pragma mark --> 当用户按下按钮，或者关机，程序都会被终止。当一个程序将要正常终止时会调用 applicationWillTerminate 方法。但是如果长主按钮强制退出，则不会调用该方法。这个方法该执行剩下的清理工作，比如所有的连接都能正常关闭，并在程序退出前执行任何其他的必要的工作.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark --  NSLog(@"\n ===> 程序开始 !");
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *versionCache = [HsConfig readUserDefaultWithKey:VersionCache];//本地缓存的版本号  第一次启动的时候本地是没有缓存版本号的。
    if (![versionCache isEqualToString:APPVERSION]){
        //如果本地缓存的版本号和当前应用版本号不一样，则是第一次启动（更新版本也算第一次启动）
        if([[HsConfig readUserDefaultWithKey:Begin_Guidance_Type] isEqualToString:@"1"]){
            //⚠️第二种: 采用引导图的方式
            GuidanceController *guiCtrl = [[GuidanceController alloc] init];
            self.window.rootViewController = guiCtrl;
        }else{
            //⚠️第一种: 采用视频播放的方式
            MovieViewController *wsCtrl = [[MovieViewController alloc]init];
            self.window.rootViewController = wsCtrl;
        }
    }else{
        //不是首次启动
        MainTabBarViewController *tabBar = [[MainTabBarViewController alloc] init];
        self.window.rootViewController = tabBar;
    }
    [self.window makeKeyAndVisible];
    
#ifdef DEBUG
    [self createFPS];
#endif
    
    [CrashHandler sharedInstance];
    
    __weak typeof(self) weakSelf = self;
    [[CrashHandler sharedInstance] crash:^{
        [weakSelf showFriendlyTips];
    }];
    
    /// 设置桌面长按touch
    [self longPressFunction];
    
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    //本地推送
    [self requestAuthor];
    
    return YES;
}

#pragma mark -- FPS调试工具
- (void)createFPS{
    CGRect frame = CGRectMake(0, 300, 80, 30);
    UIColor *btnBGColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    DDFPSButton *btn = [DDFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
    [self.window addSubview:btn];
}

// 本方法可以自行替换
- (void)showFriendlyTips{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"☀️" message:@"亲爱的小朋友，你的App 发生了神秘故障，需要重新修复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:@"👌👌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self resetApp];
    }];
    [alertController addAction:skipAction];
    [[[GetTopVCTool shareInstance] topViewController] presentViewController:alertController animated:YES completion:nil];
}

// 重置App 的根控制器（可以改成你需要的）
- (void)resetApp{
    UIViewController *topmostVC = [[GetTopVCTool shareInstance] topViewController];
    [topmostVC.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 设置桌面3D Touch
- (void)longPressFunction{
    NSArray * titleArr = @[@"切换App Logo",@"九宫格密码"];
    NSArray * typeArr = @[@"change",@"ninePassword"];
    NSMutableArray * dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<titleArr.count; i++) {
        // 创建标签的ICON图标。
        UIApplicationShortcutIcon *icon;
        if (i==0) {
            icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
        }else if(i==1){
            if (@available(iOS 9.1, *)) {
                icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
            } else {
                // Fallback on earlier versions
                icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
            }
        }
        // 创建一个标签，并配置相关属性。
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:typeArr[i] localizedTitle:titleArr[i] localizedSubtitle:nil icon:icon userInfo:nil];
        [dataArr addObject:item];
    }
    
    // 将标签添加进Application的shortcutItems中。
    [UIApplication sharedApplication].shortcutItems = dataArr;
}

// 处理从3D Touch进来后的逻辑
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    BaseViewController *vc = nil;
    if ([shortcutItem.type isEqualToString:@"change"]) {
        vc = [[NSClassFromString(@"ChangeLogoViewController") alloc] init];
    }else if ([shortcutItem.type isEqualToString:@"ninePassword"]) {
        vc = [[NSClassFromString(@"SudokuViewController") alloc] init];
    }
    if(vc != nil){
        vc.navTitle = shortcutItem.localizedTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [[[GetTopVCTool shareInstance] topViewController].navigationController pushViewController:vc animated:YES];
    }
    if (completionHandler) {
        completionHandler(YES);
    }
}

#pragma mark --- 在AppDelegate中写：强制使用系统键盘 >=iOS8
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}

#pragma mark --- 创建本地通知
- (void)requestAuthor{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];        
    }
}

@end
