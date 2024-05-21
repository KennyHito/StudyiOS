//
//  DDToast.h
//  DDDevLib
//
//  Created by Radar on 13-8-29.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//
//PS: 目前仅支持iPhone使用，iPad如果需要使用，需要继续完善
/*
使用方法: (本类只需要使用类方法即可)
1. 延时关闭方式
 [DDToast showToast:ToastTypeSuccess text:@"演示文字" closeAfterDelay:2];       //不卡住屏幕
 或者
 [DDToast showMaskToast:ToastTypeSuccess text:@"演示文字" closeAfterDelay:2];   //卡住屏幕
 
2. 手动开启和关闭方式
 [DDToast showToast:ToastTypeSuccess text:@"演示文字"];
 [DDToast closeToast];
*/


#import <UIKit/UIKit.h>

#define new_wait_toast_height 98.f //带转圈的新toast高度
#define new_wait_toast_width 140.f //带转圈的新toast宽度

typedef enum {
    ToastTypeBlank,     //空白，只有文字
    ToastTypeWaiting,   //等待状态
    ToastTypeWarnning,  //叹号状态
    ToastTypeSuccess,   //对勾状态
    ToastTypeFailed     //叉子或者哭脸状态
} ToastType; //toast类型


@interface DDToast : UIView {
    UIView *_backMaskView;//底层的遮罩
    UIImageView *_imageView;
    UILabel *_textLabel;
}

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UILabel *textLabel;

#pragma mark -
#pragma mark 本类仅使用类方法即可

/**
 *  type1:显示一个过几秒会消失的toast
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 */
+ (void)showToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;       //不卡住屏幕，手指点击穿透, 一般都使用这个

/**
 *  同type1，并没有其它功能，从5.2.0后不要使用
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 */
+ (void)showMaskToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;


/// 默认toast
/// @param text 文字
+ (void)showToast:(NSString*)text;

/**
 *  同type1，但是不会自动关闭
 *
 *  @param type 显示的种类，当前只有waiting是有效的
 *  @param text 文字
 */
+ (void)showToast:(ToastType)type text:(NSString*)text; //这个是卡住屏幕并等待配套使用，必须使用closeToast关闭，否则无法自动关闭

/**
 *  type1:显示一个过几秒会消失的toast,有些特殊的页面需要显示在上面，所以加了这个参数
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 *  @param showAbove 是否置顶
 */
+ (void)showToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay showAbove:(BOOL)showAbove;


/**
 *  同type1，并没有其它功能，从5.2.0后不要使用
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 */
+ (void)showLayerToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;

/**
 *  同type1，并没有其它功能，从5.2.0后不要使用
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 */
+ (void)showLayerMaskToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;

/**
 *  同type1，但是不会自动关闭
 *
 *  @param type 显示的种类，当前只有waiting是有效的
 *  @param text 文字
 */
+ (void)showLayerToast:(ToastType)type text:(NSString*)text;

//关闭toast
+ (void)closeToast;

//关闭toast无动画
+ (void)closeToastNOAnimated;

@end
