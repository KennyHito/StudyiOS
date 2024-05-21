//
//  AlertControTool.m
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import "AlertControTool.h"

@implementation AlertControTool

/* UIAlertController提示框 */
+ (void)alertTitle:(NSString *)title andMessage:(NSString *)message andAction1:(NSString *)cancelActionStr andAction2:(NSString *)rubbishActionStr andBlock:(alertBlock)block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]]){
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]]){
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionStr style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //简直废话:style:UIAlertActionStyleDestructive
    UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:rubbishActionStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        block(0);
    }];
    [alertController addAction:rubbishAction];
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
