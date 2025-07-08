//
//  UIView+CommonView.h
//  StudyiOS
//
//  Created by Apple on 2025/7/8.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonActionBlock)(UIButton * _Nonnull button);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CommonView)

- (UILabel *)createLabelTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackColor:(UIColor *)backColor andTag:(int)tag andFrame:(CGRect)frame andTextAlignment:(NSTextAlignment)align;

- (UIButton *)createButtonTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor *)backgroundColor andFrame:(CGRect)frame actionBlock:(ButtonActionBlock)block;

@end

NS_ASSUME_NONNULL_END
