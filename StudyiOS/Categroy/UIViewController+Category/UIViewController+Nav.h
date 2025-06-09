//
//  UIViewController+Nav.h
//  StudyiOS
//
//  Created by Apple on 2025/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Nav)
/**
 设置自定义返回按钮
 */
- (void)setupCustomBackButton;

/**
 自定义返回按钮点击事件
 */
- (void)customBackAction;

@end

NS_ASSUME_NONNULL_END
