//
//  DDToast.m
//  DDDevLib
//
//  Created by Radar on 13-8-29.
//  Copyright (c) 2013年 www.dangdang.com. All rights reserved.
//

#import "DDToast.h"

#define loading_icon_width 37.f

#define TOASTTAG 15265

#ifndef DDFONT
#define DDFONT(x) [UIFont systemFontOfSize:x]
#endif

#ifndef RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

#ifndef DDFONT_B
#define DDFONT_B(x) [UIFont boldSystemFontOfSize:x]
#endif

#ifndef ATINT
#define ATINT(x) (int)([UIScreen mainScreen].bounds.size.width/375.0*(x))
#endif

@interface DDToast ()

@property (nonatomic, strong) UILabel* textLabel;

- (void)showToast;
- (void)closeToast;


/**
 *  创建需要显示图片的样式,现在使用的场景是需要一个需要显示加载态的场景，waitingType
 *
 *  @param text 要显示的文字
 *
 *  @return DDToast对象
 */
- (id)initWaitingType:(NSString*)text;


///**
// *  封装设置text的方法，因为得处理两行的情况
// */
//- (void)setText:(NSString*)text;
@end

#pragma mark - DDNewToast

@interface DDNewToast:DDToast

@property (nonatomic, strong) UILabel* label_text;

@end

@implementation DDToast


- (id)initWaitingType:(NSString*)text
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds));
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _backMaskView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-new_wait_toast_width)/2, ([UIScreen mainScreen].bounds.size.height-new_wait_toast_height)/2, new_wait_toast_width, new_wait_toast_height)];
        _backMaskView.alpha = 0;
        _backMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _backMaskView.layer.cornerRadius = 8.f;
        [self addSubview:_backMaskView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((new_wait_toast_width-loading_icon_width)/2, 21.f, loading_icon_width, loading_icon_width)];
        [_backMaskView addSubview:self.imageView];
        
        if(text && ![text isEqualToString:@""]) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65.f, new_wait_toast_width, (new_wait_toast_height-65.f)/2)];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.backgroundColor = [UIColor clearColor];
            _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _textLabel.textColor = [UIColor whiteColor];
            _textLabel.font = DDFONT(14);
            [_backMaskView addSubview:_textLabel];
        }else{
            self.imageView.frame = CGRectMake((new_wait_toast_width-loading_icon_width)/2, (new_wait_toast_height-loading_icon_width)/2, loading_icon_width, loading_icon_width);
            [_backMaskView addSubview:self.imageView];
        }
    }
    return self;
}

- (void)dealloc {
    _backMaskView = nil;
    _imageView = nil;
    _textLabel = nil;
}

#pragma mark -
#pragma mark in use functions

-(void)newShowToast{
    //qz:用于等待、加载等页面 140*98 带打转的图片36*36
    
    self.imageView.image = [UIImage imageNamed:@"loading-icon.png"];
    [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(imageCircle) userInfo:nil repeats:YES];
    [UIView beginAnimations:@"show_toast" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    _backMaskView.alpha = 1;
    [UIView commitAnimations];
}

-(void)imageCircle{
    self.imageView.layer.transform = CATransform3DRotate(self.imageView.layer.transform, M_PI/10, 0.0f, 0.0f, 1.0f);
}

- (void)showToast
{
    _backMaskView.alpha = 0;
    [UIView beginAnimations:@"show_toast" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    _backMaskView.alpha = 1;
    [UIView commitAnimations];
}

- (void)closeToast
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self superview]) {
            [self removeFromSuperview];
        }
    }];
}

- (void)closeToastNoAnimaed
{
    self.alpha = 0;
    [self removeFromSuperview];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(animationID && [animationID compare:@"close_toast"] == NSOrderedSame)
    {
        if([self superview])
        {
            [self removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark out use functions

+ (void)showToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(type == ToastTypeWaiting)
        {
            DDToast *toast = [[DDToast alloc] initWaitingType:text];
            toast.tag = TOASTTAG;
            if(text && ![text isEqualToString:@""])
            {
                toast.textLabel.text = text;
            }
            
            [[UIApplication sharedApplication].keyWindow addSubview:toast];
            [toast newShowToast];
            [toast performSelector:@selector(closeToast) withObject:nil afterDelay:delay];
        }
        else
        {
            [DDNewToast showToast:type text:text closeAfterDelay:delay];
        }
    });
}

+ (void)showMaskToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(type == ToastTypeWaiting)
        {
            DDToast *toast = [[DDToast alloc] initWaitingType:text];
            toast.tag = TOASTTAG;
            [toast.textLabel setText:text];
            
            [[UIApplication sharedApplication].keyWindow addSubview:toast];
            [toast newShowToast];
            [toast performSelector:@selector(closeToast) withObject:nil afterDelay:delay];
        }else{
            
            [DDNewToast showToast:type text:text closeAfterDelay:delay];
        }
    });
}

/// 默认toast
/// @param text 文字
+ (void)showToast:(NSString*)text
{
    if (![text isKindOfClass:NSString.class]) {
        return;
    }
    if (text.length <= 0) {
        return;
    }
    [self showToast:ToastTypeBlank text:text];
}

+ (void)showToast:(ToastType)type text:(NSString*)text
{
    if (![text isKindOfClass:NSString.class]) {
        return;
    }
    if (text.length <= 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *content = text;
        if (![text isKindOfClass:[NSString class]]) {
            content = @"";
        }
        if(type == ToastTypeWaiting)
        {
            DDToast *toast = [[DDToast alloc] initWaitingType:text];
            toast.tag = TOASTTAG;
            [toast.textLabel setText:text];
            
            [[UIApplication sharedApplication].keyWindow addSubview:toast];
            [toast newShowToast];
        } else {
            //#warning 这里还得考虑特殊情况，不是waiting但也得阻挡的情况
            [DDNewToast showToast:type text:content closeAfterDelay:2];
        }
    });
}

+ (void)showLayerToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay
{
    [self showToast:type text:text closeAfterDelay:delay];
}

+ (void)showLayerMaskToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay
{
    [self showMaskToast:type text:text closeAfterDelay:delay];
}

+ (void)showLayerToast:(ToastType)type text:(NSString*)text
{
    [self showToast:type text:text];
}

//关闭toast
+ (void)closeToast
{
    DDToast *toast = (DDToast*)[[UIApplication sharedApplication].keyWindow viewWithTag:TOASTTAG];
    if(toast)
    {
        [toast closeToast];
    }
}

//关闭toast无动画
+ (void)closeToastNOAnimated
{
    DDToast *toast = (DDToast*)[[UIApplication sharedApplication].keyWindow viewWithTag:TOASTTAG];
    if(toast)
    {
        [toast closeToastNoAnimaed];
    }
}

/**
 *  type1:显示一个过几秒会消失的toast,有些特殊的页面需要显示在上面，所以加了这个参数
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 *  @param showAbove 是否置顶
 */
+ (void)showToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay showAbove:(BOOL)showAbove
{
    [DDNewToast showToast:type text:text closeAfterDelay:delay showAbove:showAbove];
}
@end

#pragma mark - NEW TOAST
@implementation DDNewToast

+ (void)closeToastForce:(BOOL)force
{
    if (!force)
    {
        [super closeToast];
    }
    else
    {
        //get and close
        DDNewToast *toast = (DDNewToast*)[[UIApplication sharedApplication].keyWindow viewWithTag:TOASTTAG];
        if(toast && [toast isKindOfClass:[DDNewToast class]])
        {
            [toast closeToastForce:YES];
        }
        else
        {
            [toast closeToast];
        }
    }
}

- (void)closeToastForce:(BOOL)force
{
    if (!force)
    {
        [super closeToast];
    }
    else
    {
        if (self.superview)
        {
            [self removeFromSuperview];
        }
    }
}

- (void)dealloc {
    _label_text = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _label_text = [[UILabel alloc]initWithFrame:CGRectMake(ATINT(0), 0, CGRectGetWidth(self.bounds) - ATINT(0) * 2, CGRectGetHeight(self.bounds))];
        _label_text.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _label_text.backgroundColor = [UIColor clearColor];
        _label_text.textColor = [UIColor whiteColor];
        _label_text.textAlignment = NSTextAlignmentCenter;
        _label_text.font = DDFONT(15);
        _label_text.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        //        self.backgroundColor = RGBA(245, 105, 90, 0.9);
        self.backgroundColor=[UIColor blackColor];
        self.tag = TOASTTAG;
        [self addSubview:_label_text];
    }
    return self;
}

+ (void)showToast:(ToastType)type text:(NSString *)text closeAfterDelay:(NSTimeInterval)delay
{
    [self showToast:type text:text closeAfterDelay:delay showAbove:NO];
}


/**
 *  type1:显示一个过几秒会消失的toast
 *
 *  @param type  显示的种类，当前只有waiting是有效的
 *  @param text  文字
 *  @param delay 关闭的时间
 *  @param showAbove 是否置顶
 */
+ (void)showToast:(ToastType)type text:(NSString*)text closeAfterDelay:(NSTimeInterval)delay showAbove:(BOOL)showAbove
{
    //移除旧的
    [self closeToastForce:YES];
    //添加新的
    CGRect bounds = [UIApplication sharedApplication].keyWindow.bounds;
    //    如果当前最上层的有Tabbar，则不再上移xx像素
    
    float height_toast = 49;
    float y_toast = CGRectGetHeight(bounds) - height_toast;
    //支付页H5SettlementViewController
    
    //如果需要吸顶
    if (showAbove)
    {
        y_toast = 0;
    }
    CGRect frame = CGRectMake(0, y_toast, CGRectGetWidth(bounds), height_toast);
    DDNewToast* toast = [[DDNewToast alloc]initWithFrame:frame];
    toast.alpha =0;
    [toast setText:text];
    
    
    //修正toast大小
    CGSize size = [text sizeWithFont:DDFONT_B(15) constrainedToSize:CGSizeMake(toast.label_text.frame.size.width, 1000.0) lineBreakMode:NSLineBreakByWordWrapping];
    //    [toast.label_text sizeThatFits:CGSizeMake(size.width+30,toast.label_text.frame.size.height)];
    //    [toast.label_text sizeToFit];
    
    toast.layer.cornerRadius=5.0;
    
    //    KLog(@"%f====width",[UIApplication sharedApplication].keyWindow.frame.size.width);
    
    toast.frame=CGRectMake(frame.origin.x,frame.origin.y, size.width+ATINT(30)*2, 35);
    if (size.width>[UIApplication sharedApplication].keyWindow.frame.size.width-ATINT(30)*2-ATINT(20)*2) {
        //        toast.label_text.frame=CGRectMake(ATINT(45), toast.label_text.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-ATINT(45)*2, toast.label_text.frame.size.height);
        //        toast.label_text.backgroundColor=[UIColor yellowColor];
        
        toast.frame=CGRectMake(frame.origin.x,frame.origin.y, [UIApplication sharedApplication].keyWindow.frame.size.width-ATINT(20)*2, 50);
        
        toast.label_text.frame=CGRectMake(ATINT(30), toast.label_text.frame.origin.y,CGRectGetWidth(toast.frame)-
                                          
                                          (30)*2, toast.label_text.frame.size.height);
        
        toast.label_text.numberOfLines=2;
        //        toast.label_text.textAlignment=NSTextAlignmentLeft;
        
    } else if ([toast.label_text.text containsString:@"\n"]) {
        toast.label_text.numberOfLines = 2;
        toast.frame = CGRectMake(frame.origin.x,frame.origin.y, toast.label_text.frame.size.width, 50);
    }
    
    toast.center = CGPointMake([UIApplication sharedApplication].keyWindow.frame.size.width/2, [UIApplication sharedApplication].keyWindow.frame.size.height/2);
    
    
    // 处理6s 以下的小屏幕手机弹起键盘时，toast被遮挡问题
    BOOL isShowingKeyboard = NO;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        NSString *windowName = NSStringFromClass(window.class);
        // UIRemoteKeyboardWindow
        if ([windowName isEqualToString:@"UIRemoteKeyboardWindow"]) {
            isShowingKeyboard = YES;
        }
    }
    if (isShowingKeyboard) {
        if ( [UIScreen mainScreen].bounds.size.height <= 600) {  //5s se
            toast.center = CGPointMake([UIApplication sharedApplication].keyWindow.frame.size.width/2, [UIApplication sharedApplication].keyWindow.frame.size.height/2 - 30);
        } else if ( [UIScreen mainScreen].bounds.size.height <= 680) { // 6s
            toast.center = CGPointMake([UIApplication sharedApplication].keyWindow.frame.size.width/2, [UIApplication sharedApplication].keyWindow.frame.size.height/2 - 25);
        }
    }
    
    toast.label_text.center =CGPointMake(toast.frame.size.width/2, toast.frame.size.height/2);
    
    if (showAbove)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        });
    }
    //    else
    //    {
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    //    }
    
    [UIView animateWithDuration:0.2 animations:^{
        toast.alpha = 0.7;
    } completion:^(BOOL finished) {
    }];
    [toast performSelector:@selector(closeToast) withObject:nil afterDelay:delay];
}

- (void)setText:(NSString*)text{
    _label_text.text = text;
    //如果只有一行，numberOfLine为1
    CGSize tsize = [_label_text.text boundingRectWithSize:CGSizeMake(_label_text.frame.size.width,1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:DDFONT(12.)} context:nil].size;
    //否则设置为两行
    if (24 < tsize.height) {
        _label_text.textAlignment = NSTextAlignmentCenter;
        _label_text.numberOfLines = 2;
    } else {
        _label_text.textAlignment = NSTextAlignmentCenter;
        _label_text.numberOfLines = 1;
    }
}

@end
