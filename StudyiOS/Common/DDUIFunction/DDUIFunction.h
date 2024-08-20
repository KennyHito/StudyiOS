//
//  DDUIFunction.h
//  DDDevLib
//
//  Created by liuxubing on 28/11/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DDUIFunction : NSObject

+ (void)removeAllAnimationsFromView:(UIView *)view;
+ (void)addScaleAnimateForView:(UIView *)view;
+ (void)addScaleAnimateForView:(UIView *)view duration:(NSTimeInterval)duration;

//四边都加上阴影
+ (void)renderViewShadow:(UIView *)aView;
//上下两边加上阴影
+ (void)renderViewShadowVertical:(UIView *)aView;

+(CGSize)ddIPadScreenSize;

//tap手势
+ (void)addViewTapGesture:(UIView *)view delegate:(id)delegate action:(SEL)selector;

//长按手势
+ (void)addViewLongPressGesture:(UIView *)view delegate:(id)delegate action:(SEL)selector;

//指定圆角
+(CAShapeLayer *)setCornerRadius:(UIView *)view roundingCorners:(UIRectCorner)radiusCorner cornerRadii:(CGSize)cornerRadii;

// 判断一个view 是否在当前屏幕
+ (BOOL)isDisplayingInScreen:(UIView *)curView;

+ (BOOL)isDisplayingInScreenTopCenter:(UIView *)curView;


#pragma mark -
#pragma mark 系统版本
//新的判断iPhone X系列手机（刘海屏）的方法 by yl
+ (BOOL)isIPhoneX; // 是否是全面屏

+ (CGFloat)getSafeAreaTop;
+ (CGFloat)getSafeAreaBottom;
+ (CGFloat)getSafeAreaLeft;
+ (CGFloat)getSafeAreaRight;

@end
