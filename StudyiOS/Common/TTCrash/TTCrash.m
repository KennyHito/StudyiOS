//
//  TTCrash.m
//  iOSTest
//
//  Created by KennyHito on 2022/9/2.
//

#import "TTCrash.h"
#import "AppDelegate.h"

static BOOL isStop = NO;

@implementation TTCrash

void uncaughtExceptionHandler(NSException * exception){
    //获取系统当前时间，（注：用[NSDate date]直接获取的是格林尼治时间，有时差）
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *crashTime = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"HH-mm-ss"];
    NSString *crashTimeStr = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyyMMdd"];

    NSString *crashDate = [formatter stringFromDate:[NSDate date]];
    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    //出现异常的原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    //拼接错误信息
    NSString *exceptionInfo = [NSString stringWithFormat:@"CrashTime: %@\nException reason: %@\nException name: %@\nException call stack:%@\n", crashTime, name, reason, stackArray];

    //把错误信息保存到本地文件，设置errorLogPath路径下
    //并且经试验，此方法写入本地文件有效。
    NSString *errorLogPath = [NSString stringWithFormat:@"%@/CrashLogs/%@/", NSHomeDirectory(), crashDate];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:errorLogPath]) {
        [manager createDirectoryAtPath:errorLogPath withIntermediateDirectories:true attributes:nil error:nil];
    }

    errorLogPath = [errorLogPath stringByAppendingFormat:@"%@.log",crashTimeStr];
    NSError *error = nil;
    BOOL isSuccess = [exceptionInfo writeToFile:errorLogPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!isSuccess) {
        KLog(@"将crash信息保存到本地失败: %@", error.userInfo);
    }else{
        KLog(@"crash信息保存到本地成功: %@",errorLogPath);
    }
    
    
    /**
     起死回生
     */
    CFRunLoopRef currentRunloop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(currentRunloop);
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有bug的问题" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        isStop = YES;
    }];
    [alertC addAction:action1];
    [[TTCrash getTopViewController] presentViewController:alertC animated:YES completion:nil];
    
    while (!isStop){// 根据需要可改条件判断
        for (NSString* modePilot in (__bridge NSArray*)allModes){
            CFRunLoopRunInMode((CFStringRef)modePilot, 0.0001, NO);
        }
    }
    CFRelease(allModes);
}

+ (void)installUncaughtSignalExceptionHandler{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

/**
 获取当前View的顶层控制器
 
 @return 当前最顶层控制器
 */
+ (UIViewController *)getTopViewController {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *topViewController = appDelegate.window.rootViewController;
    while (topViewController) {
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = [(UITabBarController *)topViewController selectedViewController];
        }
        else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        }
        else if ([topViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
            topViewController = topViewController.presentedViewController;
        }
        else {
            break;
        }
    }
    return topViewController;
}
@end
