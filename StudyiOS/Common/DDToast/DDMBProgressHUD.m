//
//  DDMBProgressHUD.m
//  当当
//
//  Created by DDiOS on 2020/3/23.
//  Copyright © 2020 DangDang. All rights reserved.
//

#import "DDMBProgressHUD.h"

typedef void (^DDMBProgressHUDSettingBlock)(UIView *view);
@interface DDMBProgressHUD()

@end

@implementation DDMBProgressHUD

#pragma mark - ================= 中间有 icon =================
+(MBProgressHUD *)showInWindowIconImage:(UIImage *)iconImage tipText:(NSString *)text {
    return [self showInWindowIconImage:iconImage tipText:text delayClose:1.5];
}

+(MBProgressHUD *)showInWindowIconImage:(UIImage *)iconImage tipText:(NSString *)text delayClose:(NSTimeInterval)delay {
    return [self showInView:[UIApplication sharedApplication].keyWindow iconImage:iconImage tipText:text delayClose:delay];
}


+(MBProgressHUD *)showInView:(UIView *)addView iconImage:(UIImage *)iconImage tipText:(NSString *)text delayClose:(NSTimeInterval)delay {
    return [self showInView:addView iconImage:iconImage tipText:text delayClose:delay resetImageView:^(UIView *iconImageView) {
        //可以自己设置icon的属性
        
    }];
}

#pragma mark -  ================= 中间无 icon  =================
+(MBProgressHUD *)showInWindowTipText:(NSString *)text {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self showInView:[UIApplication sharedApplication].keyWindow iconImage:nil tipText:text delayClose:1.5];
    
#pragma clang diagnostic pop
}

+(MBProgressHUD *)showInView:(UIView *)addView tipText:(NSString *)text delayClose:(NSTimeInterval)delay {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self showInView:addView iconImage:nil tipText:text delayClose:delay];
    
#pragma clang diagnostic pop
}


#pragma mark - ================= 公用的方法，可以自己拓展  =================
+(MBProgressHUD *)showInView:(UIView *)addView iconImage:(UIImage *)iconImage tipText:(NSString *)text delayClose:(NSTimeInterval)delay resetImageView:(DDMBProgressHUDSettingBlock)setImageBlock {
    
    UIImageView *imageView = nil;
    if (iconImage) {
        imageView = [[UIImageView alloc] initWithImage:iconImage];
        imageView.tintColor = [UIColor whiteColor];
        imageView.backgroundColor = [UIColor clearColor];
    }
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:addView animated:YES];
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.79];
    hub.mode = MBProgressHUDModeCustomView;
    if (iconImage) {
        hub.customView = imageView;
    }
    hub.label.text = text;
    hub.label.textColor = [UIColor whiteColor];
    hub.removeFromSuperViewOnHide = YES;
    [hub hideAnimated:YES afterDelay:delay];
    if (setImageBlock) {
        setImageBlock(imageView);
    }
    return hub;
}
@end
