//
//  ScreenShotViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/3.
//

#import "ScreenShotViewController.h"
#import "DPScreenshotsPopView.h"

@interface ScreenShotViewController ()

@end

@implementation ScreenShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * iv = [[UIImageView alloc]init];
    iv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:@"timg"];
    [self.view addSubview:iv];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification{
    NSLog(@"检测到截屏");
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [self imageWithScreenshot];
    UIWindow *keyWindow=[[UIApplication sharedApplication]keyWindow];
    DPScreenshotsPopView *popView=[DPScreenshotsPopView initWithScreenShots:image_ selectSheetBlock:^(SelectSheetType type) {
        if (type==QQSelectSheetType) {
            NSLog(@"点击的是QQ分享");
        }else if (type==WeiXinSelectSheetType){
            NSLog(@"点击的是微信好友分享");
        }else if (type==WeiXinCircleSelectSheetType){
            NSLog(@"点击的是微信朋友圈分享");
        }
    }];
    [popView show];
    
    [keyWindow addSubview:popView];
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

@end

