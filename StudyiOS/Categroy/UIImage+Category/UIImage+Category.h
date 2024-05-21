//
//  UIImage+Category.h
//  StudyiOS
//
//  Created by Apple on 2023/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)

#pragma mark -- 颜色转图片
+ (UIImage*)createImageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
