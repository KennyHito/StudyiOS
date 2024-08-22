//
//  MasonryViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/22.
//

#import "MasonryViewController.h"

@interface MasonryViewController ()

@end

@implementation MasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    UIView *superview = self.bgView;
    superview.backgroundColor = [UIColor orangeColor];
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor greenColor];
    [superview addSubview:view1];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 15, 10, 15);//上 左 下 右
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(superview.mas_top).with.offset(padding.top);
        make.left.mas_equalTo(superview.mas_left).with.offset(padding.left);
        make.bottom.mas_equalTo(superview.mas_bottom).with.offset(-padding.bottom);
        make.right.mas_equalTo(superview.mas_right).with.offset(-padding.right);
    }];
    
    UIEdgeInsets padding1 = UIEdgeInsetsMake(25, 30, 25, 30);
    UIView * view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor yellowColor];
    [superview addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superview).with.insets(padding1);
    }];
    
    /// btn
    UIButton * btn = [[UIButton alloc]init];
    [btn setTitle:@"btn" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [view2 addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view2.mas_top);//上
        make.left.mas_equalTo(view2.mas_left);//左
        make.width.mas_equalTo(view2.mas_width);//宽
        make.height.mas_equalTo(50);//高
    }];
    
    /// btn1
    UIButton * btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor blueColor];
    [view2 addSubview:btn1];
    
    /// btn2
    UIButton * btn2 = [[UIButton alloc]init];
    [btn2 setTitle:@"btn2" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor darkGrayColor];
    [view2 addSubview:btn2];
    
    int padding_t = 10;
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view2.mas_left).offset(padding_t);
        make.top.mas_equalTo(btn.mas_bottom).offset(padding_t);
        make.height.mas_equalTo(150);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view2.mas_right).offset(-padding_t);
        make.top.mas_equalTo(btn1.mas_top);
        make.height.width.mas_equalTo(btn1);
        make.left.mas_equalTo(btn1.mas_right).with.offset(padding_t);
    }];
    
    /// btn3
    UIButton * btn3 = [[UIButton alloc]init];
    btn3.backgroundColor = [UIColor cyanColor];
    [btn3 setTitle:@"btn3" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view2 addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(10);
        make.centerX.equalTo(btn1);
        make.width.equalTo(btn1);
        make.height.equalTo(btn1);
    }];
    
    /// btn4
    UIButton * btn4 = [[UIButton alloc]init];
    btn4.backgroundColor = [UIColor purpleColor];
    [btn4 setTitle:@"btn4" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view2 addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view2);
        make.top.equalTo(btn3.mas_bottom).offset(10);
        make.width.equalTo(btn1);
        make.height.equalTo(btn1);
    }];
}

@end
