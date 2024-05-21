//
//  DDUIFunction.m
//  DDDevLib
//
//  Created by liuxubing on 28/11/14.
//  Copyright (c) 2014 www.dangdang.com. All rights reserved.
//

#import "DDUIFunction.h"

@implementation DDUIFunction

+ (void)removeAllAnimationsFromView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return;
    }
    [view.layer removeAllAnimations];
}

+ (void)addScaleAnimateForView:(UIView *)view {
    [self addScaleAnimateForView:view duration:0.8];
}

+ (void)addScaleAnimateForView:(UIView *)view duration:(NSTimeInterval)duration {
    if (![view isKindOfClass:[UIView class]]) {
        return;
    }
    [view.layer removeAllAnimations];
    //缩放动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.9f];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:@"scaleAnimation"];
}

+ (void)renderViewShadow:(UIView *)aView{
    CGRect aframe = aView.bounds;
    
    CALayer * gradinetLayer = [CALayer layer];
    
    CAGradientLayer * gradLayerRight = [CAGradientLayer layer];
    gradLayerRight.frame = CGRectMake(CGRectGetMaxX(aframe), -0.5, 1, aframe.size.height+2.5);
    [gradLayerRight setColors:[NSArray arrayWithObjects:(id)[RGB(235, 235, 235) CGColor],(id)[RGB(238, 238, 238) CGColor], nil]];
    [gradLayerRight setLocations:@[@0.5,@0.9]];
    [gradLayerRight setStartPoint:CGPointMake(0, 0.5)];
    [gradLayerRight setEndPoint:CGPointMake(1, 0.5)];
    [gradinetLayer addSublayer:gradLayerRight];
    
    CAGradientLayer * gradLayerLeft = [CAGradientLayer layer];
    gradLayerLeft.frame = CGRectMake(-1, -0.5, 1, aframe.size.height+2.5);
    [gradLayerLeft setColors:[NSArray arrayWithObjects:(id)[RGB(238, 238, 238) CGColor],(id)[RGB(235, 235, 235) CGColor], nil]];
    [gradLayerLeft setLocations:@[@0.5,@0.9]];
    [gradLayerLeft setStartPoint:CGPointMake(0, 0.5)];
    [gradLayerLeft setEndPoint:CGPointMake(1, 0.5)];
    [gradinetLayer addSublayer:gradLayerLeft];
    
    CALayer *layerTop=[CALayer layer];
    layerTop.backgroundColor=[RGB(235, 235, 235) CGColor];
    layerTop.frame = CGRectMake(-0.5, -0.5,aframe.size.width+1, 0.5);
    [gradinetLayer addSublayer:layerTop];
    
    CALayer * gradLayerBottom1 = [CALayer layer];
    gradLayerBottom1.frame = CGRectMake(0, aframe.size.height, aframe.size.width, 0.5);
    gradLayerBottom1.backgroundColor=[RGB(225, 225, 225) CGColor];
    [gradinetLayer addSublayer:gradLayerBottom1];
    
    
    CALayer * gradLayerBottom2 = [CALayer layer];
    gradLayerBottom2.frame = CGRectMake(0, aframe.size.height+0.5, aframe.size.width, 1.5);
    gradLayerBottom2.backgroundColor=[RGB(235, 235, 235) CGColor];
    [gradinetLayer addSublayer:gradLayerBottom2];
    
    [aView.layer addSublayer:gradinetLayer];
}

+ (void)renderViewShadowVertical:(UIView *)aView{
    CGRect aframe = aView.bounds;
    
    CALayer * gradinetLayer = [CALayer layer];
    
//    CAGradientLayer * gradLayerRight = [CAGradientLayer layer];
//    gradLayerRight.frame = CGRectMake(CGRectGetMaxX(aframe), -0.5, 1, aframe.size.height+2.5);
//    [gradLayerRight setColors:[NSArray arrayWithObjects:(id)[RGB(235, 235, 235) CGColor],(id)[RGB(238, 238, 238) CGColor], nil]];
//    [gradLayerRight setLocations:@[@0.5,@0.9]];
//    [gradLayerRight setStartPoint:CGPointMake(0, 0.5)];
//    [gradLayerRight setEndPoint:CGPointMake(1, 0.5)];
//    [gradinetLayer addSublayer:gradLayerRight];
//    
//    CAGradientLayer * gradLayerLeft = [CAGradientLayer layer];
//    gradLayerLeft.frame = CGRectMake(-1, -0.5, 1, aframe.size.height+2.5);
//    [gradLayerLeft setColors:[NSArray arrayWithObjects:(id)[RGB(238, 238, 238) CGColor],(id)[RGB(235, 235, 235) CGColor], nil]];
//    [gradLayerLeft setLocations:@[@0.5,@0.9]];
//    [gradLayerLeft setStartPoint:CGPointMake(0, 0.5)];
//    [gradLayerLeft setEndPoint:CGPointMake(1, 0.5)];
//    [gradinetLayer addSublayer:gradLayerLeft];
    
    CALayer *layerTop=[CALayer layer];
    layerTop.backgroundColor=[RGB(235, 235, 235) CGColor];
    layerTop.frame = CGRectMake(-0.5, -0.5,aframe.size.width+1, 0.5);
    [gradinetLayer addSublayer:layerTop];
    
    CALayer * gradLayerBottom1 = [CALayer layer];
    gradLayerBottom1.frame = CGRectMake(0, aframe.size.height, aframe.size.width, 0.5);
    gradLayerBottom1.backgroundColor=[RGB(225, 225, 225) CGColor];
    [gradinetLayer addSublayer:gradLayerBottom1];
    
    
    CALayer * gradLayerBottom2 = [CALayer layer];
    gradLayerBottom2.frame = CGRectMake(0, aframe.size.height+0.5, aframe.size.width, 1.5);
    gradLayerBottom2.backgroundColor=[RGB(235, 235, 235) CGColor];
    [gradinetLayer addSublayer:gradLayerBottom2];
    
    [aView.layer addSublayer:gradinetLayer];
}

+(CGSize)ddIPadScreenSize{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGSizeMake(screenSize.height, screenSize.width);
    }
    return screenSize;
    
}

+ (void)addViewTapGesture:(UIView *)view delegate:(id)delegate action:(SEL)selector
{
    if (delegate && [delegate respondsToSelector:selector]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:selector];
        [view addGestureRecognizer:tap];
    }
}

+ (void)addViewLongPressGesture:(UIView *)view delegate:(id)delegate action:(SEL)selector
{
    if (delegate && [delegate respondsToSelector:selector]) {
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:delegate action:selector];
        [view addGestureRecognizer:tap];
    }
}

+(CAShapeLayer *)setCornerRadius:(UIView *)view roundingCorners:(UIRectCorner)radiusCorner cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *paCornerRect2 = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:radiusCorner cornerRadii:cornerRadii];
    
    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    cornerLayer.frame = view.bounds;
    cornerLayer.path = paCornerRect2.CGPath;
    //    cornerLayer.fillColor = [UIColor clearColor].CGColor;   //包围区域的颜色 默认是黑色
    view.layer.mask = cornerLayer;
    
    return cornerLayer;
}

+ (BOOL)isDisplayingInScreen:(UIView *)curView {
    if (![curView isKindOfClass:UIView.class]) {
        return NO;
    }
    if (curView.hidden || !curView.superview) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [curView convertRect:curView.bounds toView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}


+ (BOOL)isDisplayingInScreenTopCenter:(UIView *)curView {
    if (![curView isKindOfClass:UIView.class]) {
        return NO;
    }
    if (curView.hidden || !curView.superview) {
        return NO;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    CGRect screenRect = CGRectMake(0, 0, width, height * 0.3);
//
    // 转换view对应window的Rect
    CGRect rect = [curView convertRect:curView.bounds toView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isIPhoneX
{
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0;
    } else {
        return NO;
    }
    
}

+ (CGFloat)getSafeAreaTop
{
    if (@available(iOS 11.0, *))
    {
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:@selector(safeAreaInsets)])
        {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

+ (CGFloat)getSafeAreaBottom
{
    if (@available(iOS 11.0, *))
    {
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:@selector(safeAreaInsets)])
        {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

+ (CGFloat)getSafeAreaLeft
{
    if (@available(iOS 11.0, *))
    {
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:@selector(safeAreaInsets)])
        {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.left;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}
+ (CGFloat)getSafeAreaRight
{
    if (@available(iOS 11.0, *))
    {
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:@selector(safeAreaInsets)])
        {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.right;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }

}


//+(DeviceType)currentDevice
//{
//    DeviceType device=iphone5s;
//    if([UIScreen instancesRespondToSelector:@selector(currentMode)])
//    {
//        CGSize  size=[[UIScreen mainScreen] currentMode].size;
//        if(CGSizeEqualToSize(CGSizeMake(640,960),size))
//        {
//            device=iphone4s;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(640,1136),size))
//        {
//            device=iphone5s;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(750,1334),size))
//        {
//            device=iphone6;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(1242,2208),size))
//        {
//            device=iphone6p;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(1242,2208),size))//iphone6p 标准模式
//        {
//            device=iphone6p;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(1125,2001),size))//iphone6p 放大模式
//        {
//            device=iphone6p;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(1125,2436),size))//iphoneX
//        {
//            device=iphoneX;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(1242,2688),size))//iPhoneXSMax
//        {
//            device=iPhoneXSMax;
//        }
//        else if(CGSizeEqualToSize(CGSizeMake(828,1792),size)||CGSizeEqualToSize(CGSizeMake(750, 1624),size))//iPhoneXR
//        {
//            device=iPhoneXR;
//        }
//        else if (CGSizeEqualToSize(CGSizeMake(1170, 2532),size)){
//            device = iPhone12;
//        }
//        else if (CGSizeEqualToSize(CGSizeMake(1170, 2532),size)){
//            device = iPhone12Pro;
//        }
//        else if (CGSizeEqualToSize(CGSizeMake(1284, 2778),size)){
//            device = iPhone12ProMax;
//        }
//        else if (CGSizeEqualToSize(CGSizeMake(1080, 2340),size)){
//            device = iPhone12Mini;
//        }
//        //    1125 X 2436px 分辨率， 458 ppi
//        //
//        //    iPhone XS Max
//        //
//        //    1242 x 2688px 分辨率，458 ppi
//        //
//        //    iPhone XR
//        //
//        //    828 X 1792px 分辨率，326ppi
//    }
//    return device;
//}


@end
