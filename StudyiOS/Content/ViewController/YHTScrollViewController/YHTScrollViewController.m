//
//  YHTScrollView.m
//  Summarize
//
//  Created by KennyHito on 16/7/16.
//  Copyright © 2016年 KennyHito. All rights reserved.
//

#import "YHTScrollViewController.h"
#import "nextViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "SocietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"
#import "musicViewController.h"

#define SCROLL_WIDTH _scrollView.bounds.size.width
#define SCROLL_HEIGHT _scrollView.bounds.size.height

static CGFloat const titleH = 44;
static CGFloat const navBarH = 200;
static CGFloat const maxTitleScale = 1.3;

@interface YHTScrollViewController ()<UIScrollViewDelegate,UITableViewDelegate>

//滚动视图
@property (nonatomic,strong) UIScrollView * scrollView;
//图片数据源
@property (nonatomic,strong) NSArray * picArr;
//NSTimer
@property (nonatomic,strong) NSTimer * time;
//点控制
@property (nonatomic,strong) UIPageControl * page;
//文字数组
@property (nonatomic,strong) NSArray * titleArr;
//UITableView
@property (nonatomic,strong) UITableView * tableView;

#pragma mark -- 新闻标题栏部分
@property (nonatomic, weak) UIScrollView * titleScrollView;
@property (nonatomic, weak) UIScrollView * contentScrollView;
// 选中按钮
@property (nonatomic, weak) UIButton * selTitleButton;
@property (nonatomic, strong) NSMutableArray * buttons;


@end

@implementation YHTScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"轮播图";
    
    //不让系统修改布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置背景色
    self.bgView.backgroundColor = [UIColor whiteColor];
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    
    
    _picArr = @[@"电脑的壁纸.jpg",@"飞机的壁纸.jpg",@"手表的壁纸.jpg"];
    _titleArr = @[@"第一张图",@"第二张图",@"第三张图"];
    
    //创建定时器
    _time = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeEvent:) userInfo:nil repeats:YES];
    
    [self createScrollView];
    
    [self createMenuView];
    
    
}

- (void)createScrollView{
    //创建滚动视图
    //[注意🐷] : 这个200的高度用户可以自行改动,后面无需改动,其他的地方会自动修改的!!!
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 200)];
    //滚动视图的大小
    _scrollView.contentSize = CGSizeMake(KScreenW * (_picArr.count+2), 200);
    //滚动视图翻页
    _scrollView.pagingEnabled = YES;
    //添加代理
    _scrollView.delegate = self;
    //取消弹性
    _scrollView.bounces = NO;
    //滚动视图的背景色
    _scrollView.backgroundColor = [UIColor grayColor];
    //设置滚动视图活动页
    _scrollView.contentOffset = CGPointMake(KScreenW , 0);
    //取消水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    //设置tag
    _scrollView.tag = 1000;
    //添加到主视图上
    [self.bgView addSubview:_scrollView];
    
    for (int i = 0; i < _picArr.count + 2; i++) {
        //创建图片视图
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * KScreenW, 0 , KScreenW, SCROLL_HEIGHT)];
        
        //将图片视图放到滚动视图上面
        [_scrollView addSubview:imageV];
        
        //存放照片
        if (i == 0) {
            imageV.image = [UIImage imageNamed:_picArr[_picArr.count - 1]];
        }else if(i == _picArr.count + 1){
            imageV.image = [UIImage imageNamed:_picArr[0]];
        }else{
            imageV.image = [UIImage imageNamed:_picArr[i-1]];
            //创建UILabel
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * KScreenW + 10,SCROLL_HEIGHT - 25,200, 21)];
            //label上的文字
            label.text = _titleArr[i-1];
            //label的颜色
            label.textColor = [UIColor orangeColor];
            //将label放到滚动视图上面
            [_scrollView addSubview:label];
        }
    }
    
    //创建点控件
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(KScreenW-120, SCROLL_HEIGHT-21, 120, 21)];
    _page.numberOfPages = _picArr.count;
    [self.bgView addSubview:_page];
}

#pragma mark -- 导航栏右侧按钮点击事件
- (void)btnClick:(UIBarButtonItem *)btn{
    nextViewController * nextVc = [[nextViewController alloc]init];
    //跳转隐藏分栏控制器
    nextVc.hidesBottomBarWhenPushed = YES;
    
    //实现跳转的翻页效果
    CATransition * trans = [CATransition animation];
    trans.type = @"pageCurl";
    trans.subtype = @"fromRight";
    trans.duration = 1;
    [self.bgView.window.layer addAnimation:trans forKey:nil];
    
    //实现页面跳转
    [self.navigationController pushViewController:nextVc animated:YES];
    
}


#pragma mark -- NSTimer事件
- (void)timeEvent:(NSTimer *) timer{
    
    NSUInteger index = _scrollView.contentOffset.x/KScreenW;
    
//    NSLog(@"---- 之前下标为 : %lu ----",index);
    
    if ((index+1) < _picArr.count+2 ) {
        index++;
        if (index == _picArr.count + 1) {
            index = 1;
        }
    }
    _scrollView.contentOffset = CGPointMake(index * KScreenW, 0);
    _page.currentPage = index-1;
    
//   NSLog(@"++++ 当前下标为 : %lu ++++",index);
    
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        //NSLog(@"滚动视图发生改变");
        NSUInteger index = _scrollView.contentOffset.x/KScreenW;
        _page.currentPage = index - 1;
        
        //NSLog(@"%lu",index);//测试语句
        
        if (index == _picArr.count + 1) {
            _scrollView.contentOffset = CGPointMake(KScreenW, 0);
            _page.currentPage = 0;
        }
        if(_scrollView.contentOffset.x == 0){
            _scrollView.contentOffset = CGPointMake(KScreenW * _picArr.count, 0);
            _page.currentPage = _picArr.count;
        }
        
    }else if(scrollView.tag == 2000 || scrollView.tag == 3000){
        
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger leftIndex = offsetX / KScreenW;
        NSInteger rightIndex = leftIndex + 1;
        
        //NSLog(@"%zd,%zd",leftIndex,rightIndex);
        
        UIButton *leftButton = self.buttons[leftIndex];
        
        UIButton *rightButton = nil;
        if (rightIndex < self.buttons.count) {
            rightButton = self.buttons[rightIndex];
        }
        
        CGFloat scaleR = offsetX / KScreenW - leftIndex;
        
        CGFloat scaleL = 1 - scaleR;
        
        CGFloat transScale = maxTitleScale - 1;
        leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
        
        rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
        
        UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
        UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
        
        [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
        [rightButton setTitleColor:rightColor forState:UIControlStateNormal];

    }
    
}


#pragma mark -- 封装
- (void)createMenuView{
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
    [self setupTitle];
    
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * KScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}


#pragma mark -- 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    // 判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, y, KScreenW, titleH);
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.tag = 3000;
    [self.bgView addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, KScreenW, KScreenH - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    contentScrollView.tag = 2000;
    //contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.bgView addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
   
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    //#warning [注意🐷] : 这里是其他界面的控制器
    
    TopLineViewController *vc = [[TopLineViewController alloc] init];
    vc.title = @"头条";
    [self addChildViewController:vc];
    
    //需要多少个控制器就写在这里......
    HotViewController * hotVC = [[HotViewController alloc]init];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    
    musicViewController * videoVC = [[musicViewController alloc]init];
    videoVC.title = @"影视";
    [self addChildViewController:videoVC];
    
    SocietyViewController *vc3 = [[SocietyViewController alloc] init];
    vc3.title = @"社会";
    [self addChildViewController:vc3];
    
    ReaderViewController *vc4 = [[ReaderViewController alloc] init];
    vc4.title = @"订阅";
    [self addChildViewController:vc4];
    
    ScienceViewController *vc5 = [[ScienceViewController alloc] init];
    vc5.title = @"科技";
    [self addChildViewController:vc5];
}

#pragma mark - 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = 100;
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        //btn.backgroundColor = [UIColor orangeColor];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        if (i == 0)
        {
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * KScreenW;
    
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    [self.selTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    
    self.selTitleButton = btn;
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * KScreenW;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, KScreenW, KScreenH - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    
}

- (void)setupTitleCenter:(UIButton *)btn
{
    
    if (self.buttons.count < 5) {
        return;
    }
    
    CGFloat offset = btn.center.x - KScreenW * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - KScreenW;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 2000 ||scrollView.tag == 3000) {
        NSUInteger i = self.contentScrollView.contentOffset.x / KScreenW;
        [self selTitleBtn:self.buttons[i]];
        [self setUpOneChildViewController:i];
    }
   
}

@end
