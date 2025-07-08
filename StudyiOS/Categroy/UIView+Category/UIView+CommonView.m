//
//  UIView+CommonView.m
//  StudyiOS
//
//  Created by Apple on 2025/7/8.
//

#import "UIView+CommonView.h"
#import <objc/runtime.h>

static const char *kButtonActionBlockKey = "kButtonActionBlockKey";

@implementation UIView (CommonView)
/* UILabel封装 */
- (UILabel *)createLabelTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackColor:(UIColor *)backColor andTag:(int)tag andFrame:(CGRect)frame andTextAlignment:(NSTextAlignment)align{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    if (size==0) {
        label.adjustsFontSizeToFitWidth = YES;
    }else{
        label.font = [UIFont systemFontOfSize:size];
    }
    label.textColor = titleColor;
    label.backgroundColor = backColor;
    label.tag = tag;
    label.textAlignment = align;
    [self addSubview:label];
    return label;
}

/* UIButton封装 */
- (UIButton *)createButtonTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor *)backgroundColor andFrame:(CGRect)frame actionBlock:(ButtonActionBlock)block {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setFrame:frame];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:CGRectGetHeight(frame)/2.0];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    // 保存Block到关联对象
    if (block) {
        objc_setAssociatedObject(btn, kButtonActionBlockKey, block, OBJC_ASSOCIATION_COPY);
        // 添加点击事件
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:btn];
    return btn;
}

- (void)buttonClicked:(UIButton *)sender {
    // 从关联对象中取出Block并执行
    ButtonActionBlock block = objc_getAssociatedObject(sender, kButtonActionBlockKey);
    if (block) {
        block(sender);
    }
}
@end
