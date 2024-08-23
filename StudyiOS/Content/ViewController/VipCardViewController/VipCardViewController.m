//
//  VipCardViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/23.
//

#import "VipCardViewController.h"

@interface VipCardViewController ()

@end

@implementation VipCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    //UIView背景颜色渐变
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, KScreenW-20, 200)];
    [self.bgView addSubview:view];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    
    // 左上角和右上角添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    //会员卡名称
    UILabel * nameLab = [self createLabelTitle:@"家乐福超市VIP会员" andFont:0 andTitleColor:[UIColor whiteColor] andBackColor:[UIColor clearColor] andTag:50 andFrame:CGRectMake(10, 20, CGRectGetWidth(view.bounds)-20, 30) andTextAlignment:NSTextAlignmentLeft];
    [view addSubview:nameLab];
    
    //会员卡名称
    UILabel * numLab = [self createLabelTitle:@"100元" andFont:0 andTitleColor:[UIColor whiteColor] andBackColor:[UIColor clearColor] andTag:50 andFrame:CGRectMake(10, CGRectGetMaxY(view.bounds)-50, CGRectGetWidth(view.bounds)-20, 30) andTextAlignment:NSTextAlignmentRight];
    [view addSubview:numLab];
    
    //为一个view添加虚线边框
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[@4, @2];
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    [view.layer addSublayer:border];
}

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
    return label;
}

@end
