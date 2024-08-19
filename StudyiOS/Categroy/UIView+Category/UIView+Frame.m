//
//  UIView+Frame.m
//  StudyiOS
//
//  Created by Apple on 2024/8/19.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
//x坐标
- (void)setX:(CGFloat)x{
    CGRect f = self.frame;
    f.origin.x = x;
    self.frame = f;
}
- (CGFloat)X{
    return self.frame.origin.x;
}

//y坐标
- (void)setY:(CGFloat)y{
    CGRect f = self.frame;
    f.origin.y = y;
    self.frame = f;
}
- (CGFloat)Y{
    return self.frame.origin.y;
}

//宽度
- (void)setWidth:(CGFloat)width{
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;
}
- (CGFloat)Width{
    return self.frame.size.width;
}

//高度
- (void)setHeight:(CGFloat)height{
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}
- (CGFloat)Height{
    return self.frame.size.height;
}

//中心点
-(void)setCenterX:(CGFloat)centerX{
    CGPoint p = self.center;
    p.x = centerX;
    self.center = p;
}
- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint p = self.center;
    p.y = centerY;
    self.center = p;
}
- (CGFloat)centerY{
    return self.center.y;
}

@end
