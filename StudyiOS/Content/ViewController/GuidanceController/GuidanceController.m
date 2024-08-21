//
//  GuidanceController.m
//  LoveLimiteFree
//
//  Created by KennyHito on 16-5-11.
//  Copyright (c) 2016年 YuHaitao. All rights reserved.
//

#import "GuidanceController.h"

@interface GuidanceController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) NSMutableArray * imagesArr;
@property(nonatomic,strong) UIPageControl * pageControl;

@end

@implementation GuidanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏隐藏
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.imagesArr = [NSMutableArray arrayWithArray:@[@"Guidance01.jpg",@"Guidance02.jpg",@"Guidance03.jpg"]];
    [self createScrollView];
    [self addSubViewsOfScrollView];
}

#pragma mark -- create scrollView

- (void)createScrollView{
    //1.创建ScrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    //设置大小
    _scrollView.contentSize = CGSizeMake(KScreenW * _imagesArr.count, KScreenH);
    //设置代理
    _scrollView.delegate = self;
    //开启翻页模式
    _scrollView.pagingEnabled = YES;
    //防止自动下滑
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, KScreenH-150, KScreenW-20, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 3;
    _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:_pageControl];
}

#pragma mark -- scrollView add subViews
- (void)addSubViewsOfScrollView{
    //添加imagesView展示图片,添加button
    //imageView 和 label 在某些情况下添加button,点击button没有任何效果
    //所以,将button添加到ScrollView上,可显示范围的最后一页,在imageView之上
    
    //1.添加ScrollView上的图片
    for (int i = 0; i < _imagesArr.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenW * i,0, KScreenW, KScreenH)];
        imageV.image = [UIImage imageNamed:_imagesArr[i]];
        [_scrollView addSubview:imageV];
    }
    
    //2.添加button
    //将button放到ScrollView的最后一个图片上面
    //所以:宽 = (count-1个屏幕宽)+(一个屏幕宽减去button宽 再除以2);
    //高 = (屏幕高)- button的高 再除以2
    UIButton * beginBtn = [[UIButton alloc]initWithFrame:CGRectMake((KScreenW - 150)/2.0 + KScreenW * (_imagesArr.count - 1), KScreenH - 100, 150, 60)];
    [beginBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    beginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    beginBtn.backgroundColor = [UIColor orangeColor];
    beginBtn.layer.borderWidth = 2;
    beginBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    beginBtn.layer.cornerRadius = 8;
    beginBtn.layer.masksToBounds = YES;
    beginBtn.tag = 1000;
    [beginBtn setTitle:@"开始体验" forState:UIControlStateNormal];
    [beginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:beginBtn];
    
    UIButton * skipBtn = [[UIButton alloc]initWithFrame:CGRectMake((KScreenW - 100) + KScreenW * (_imagesArr.count - 1), 100, 80, 40)];
    [skipBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    skipBtn.backgroundColor = [UIColor orangeColor];
    skipBtn.layer.borderWidth = 2;
    skipBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    skipBtn.layer.cornerRadius = 8;
    skipBtn.layer.masksToBounds = YES;
    skipBtn.tag = 2000;
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:skipBtn];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageIndex = scrollView.contentOffset.x/KScreenW;
    //指示按钮显示在第几页
    _pageControl.currentPage =pageIndex;
}

#pragma mark --button单击事件
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 1000) {
        //修改本地关于是否安装的标记
        [HsConfig writeUserDefaultWithKey:VersionCache WithValue:APPVERSION];
    }
    //还原状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    //切换根视图
    MainTabBarViewController *tabBar = [[MainTabBarViewController alloc] init];
    self.view.window.rootViewController = tabBar;
}

@end
