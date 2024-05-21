//
//  AppleShareViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import "AppleShareViewController.h"

@interface AppleShareViewController ()

@end

@implementation AppleShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [self createButtonTitle:@"分享一下" andFont:15 andTitleColor:[UIColor yellowColor] andBackColor:[UIColor redColor] andTag:100 andFrame:CGRectMake(KScreenW/2-50, 100, 100, 40)];
    [self.view addSubview:btn];
}

/* UIButton封装 */
- (UIButton *)createButtonTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackColor:(UIColor *)backColor andTag:(int)tag andFrame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setFrame:frame];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4.0];
    btn.backgroundColor = backColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClick:(UIButton *)btn{
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[@"您好,我是iOS开发人员。",[NSURL URLWithString:@"https://www.baidu.com"]] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
