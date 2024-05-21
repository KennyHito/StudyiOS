//
//  UIImage+Category.m
//  StudyiOS
//
//  Created by Apple on 2023/9/27.
//

#import "UIImage+Category.h"
#import <objc/runtime.h>

@implementation UIImage (Category)

///作用：把类加载进内存的时候调用,只会调用一次
///调用：方法应先交换，再去调用
+ (void)load{
    // 1.获取 imageNamed方法地址
    Method imageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
    // 2.获取 dd_imageNamed方法地址
    Method ln_imageNamedMethod = class_getClassMethod(self, @selector(dd_imageNamed:));
    // 3.交换方法地址，相当于交换实现方式;「method_exchangeImplementations 交换两个方法的实现」
    method_exchangeImplementations(imageNamedMethod, ln_imageNamedMethod);
}

// 加载图片 且 带判断是否加载成功
+ (UIImage *)dd_imageNamed:(NSString *)name {
    UIImage *image = [UIImage dd_imageNamed:name]; //⚠️这里切勿使用[UIImage imageNamed:@"2.png"],会死循环
    if (image) {
        NSLog(@"runtime交互方法 -> 图片加载成功");
    } else {
        NSLog(@"runtime交互方法 -> 图片加载失败");
    }
    return image;
}


#pragma mark -- 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
