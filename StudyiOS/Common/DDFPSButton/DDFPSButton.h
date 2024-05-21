//
//  DDFPSButton.h
//  DDFPSButtonDemo
//
//  Created by Otto on 2021/12/31.
//  Copyright © 2021年 otto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDFPSButton : UIButton

+ (instancetype)setTouchWithFrame:(CGRect)frame
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                 backgroundImage:(UIImage *)backgroundImage;

@end
