//
//  MainTabBar.m
//  HitoTheme
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "MainTabBar.h"

#define ControllerCount 4
#define TabBarHeight 49

@interface MainTabBar()

@property (nonatomic, strong) UIView *addButton;

@end

@implementation MainTabBar

- (instancetype)init {
    
    if (self = [super init]) {
        /// 设置tabbar背景色
        self.backgroundColor = [UIColor whiteColor];
        
        /// 修改线条的颜色
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
            appearance.shadowColor = [UIColor clearColor];
            appearance.backgroundColor = [UIColor whiteColor];
            [self setStandardAppearance:appearance];
        }else{
            //去掉top线
            self.shadowImage = [UIImage new];
            self.backgroundImage = [UIImage new];
        }
        
        /// 改变tabbarController文字选中颜色
        self.tintColor = [UIColor redColor];
        if ([self respondsToSelector:@selector(setBarTintColor:)]) {
            self.barTintColor = [UIColor whiteColor];
        }
        
        // 添加中间add按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[[UIImage imageNamed:@"tab_publish_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        self.addButton = addBtn;
        [self addSubview:addBtn];
    }
    return self;
}

- (void)addClick {
    if ([self.subDelegate respondsToSelector:@selector(tabBarDidClickAddItem:)]) {
        [self.subDelegate tabBarDidClickAddItem:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / (ControllerCount + 1);
    //方式一:直接改变addButton的坐标;
    //self.addButton.frame = CGRectMake((HitoScreenW - width)* 0.5, 0, width, TabBarHeight);

    //方式二:通过UIView类别的方式进行改变addButton的坐标(这种方式看着比较高大上,建议采用这种方式);
    self.addButton.X = (KScreenW - width)* 0.5;
    self.addButton.Y = 0;
    self.addButton.Width = width;
    self.addButton.Height = TabBarHeight;
    
    // 下标
    NSUInteger index = 0;
    // 判断是否为控制器按钮
    for (UIView *view in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view.class isSubclassOfClass:class]) {
            int  x = index * width;
            CGRect frame = view.frame;
            view.frame = CGRectMake(x, frame.origin.y, width, frame.size.height);
            index ++;
            if (index == 2) {
                index ++;
            }
        }
    }
}

@end
