//
//  DDMBProgressHUD.h
//  当当
//
//  Created by DDiOS on 2020/3/23.
//  Copyright © 2020 KennyHito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDMBProgressHUD : NSObject

/// HUD显示window
/// @param text 提示文字描述
+(MBProgressHUD *)showInWindowTipText:(NSString *)text;

/// HUD显示view
/// @param addView 父试图
/// @param text 提示文字描述
/// @param delay 延迟关闭的时间
+(MBProgressHUD *)showInView:(UIView *)addView tipText:(NSString *)text delayClose:(NSTimeInterval)delay;

/// HUD显示window
/// 备注：默认时间 1.5后关闭
/// @param iconImage 中间的icon
/// @param text 提示文字描述
+(MBProgressHUD *)showInWindowIconImage:(UIImage *)iconImage tipText:(NSString *)text;

/// HUD显示window
/// 备注：显示window
/// @param iconImage 中间的icon
/// @param text 提示文字描述
/// @param delay 延迟多长时间关闭
+(MBProgressHUD *)showInWindowIconImage:(UIImage *)iconImage tipText:(NSString *)text delayClose:(NSTimeInterval)delay;

/// HUD显示view
/// 备注：显示在自己的view上
/// @param addView 父试图
/// @param iconImage 中间的icon
/// @param text 提示文字描述
/// @param delay 延迟多长时间关闭
+(MBProgressHUD *)showInView:(UIView *)addView iconImage:(UIImage *)iconImage tipText:(NSString *)text delayClose:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
