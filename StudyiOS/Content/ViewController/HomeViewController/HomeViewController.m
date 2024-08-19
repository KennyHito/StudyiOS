//
//  SecondViewController.m
//  LianChuTest
//
//  Created by vp on 2022/9/29.
//

#import "HomeViewController.h"

#define Tab_Title       @"title"
#define Tab_Url         @"url"

#define CellID          @"cellid"

@interface HomeViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    [self addDropUpRefresh];
    [self addDropDownRefresh];
}

- (void)initData{
    self.dataArr = @[@{Tab_Title:@"1、使用定时器注意事项",Tab_Url:@"TimerViewController"},
                     @{Tab_Title:@"2、实时学习",Tab_Url:@"ExerciseViewController"},
                     @{Tab_Title:@"3、ReactiveObjC",Tab_Url:@"ReactiveObjCViewController"},
                     @{Tab_Title:@"4、切换App Logo",Tab_Url:@"ChangeLogoViewController"},
                     @{Tab_Title:@"5、测试崩溃一下",Tab_Url:@"TryCatchViewController"},
                     @{Tab_Title:@"6、多线程NSThread、GCD和NSOperation",Tab_Url:@"MultiThreadViewController"},
                     @{Tab_Title:@"7、Runtime",Tab_Url:@"RuntimeViewController"},
                     @{Tab_Title:@"8、CollectionView自定义标签",Tab_Url:@"CollectionViewController"},
                     @{Tab_Title:@"9、关于我们",Tab_Url:@"AboutViewController"},
                     @{Tab_Title:@"10、TableView展开收起",Tab_Url:@"TableViewController"},
                     @{Tab_Title:@"11、截图分享功能",Tab_Url:@"ScreenShotViewController"},
                     @{Tab_Title:@"12、弹球碰撞功能",Tab_Url:@"PinballProViewController"},
                     @{Tab_Title:@"13、设置九宫格密码",Tab_Url:@"SudokuViewController"},
                     @{Tab_Title:@"14、日期选择器",Tab_Url:@"DatePickerVC"},
                     @{Tab_Title:@"15、HTML5交互",Tab_Url:@"HTML5ViewController"},
                     @{Tab_Title:@"16、仿京东地址选择器",Tab_Url:@"AddressViewController"},
                     @{Tab_Title:@"17、AVPlayer播放视频",Tab_Url:@"AVPlayerViewController"},
                     @{Tab_Title:@"18、AVPlayer播放音频",Tab_Url:@"MusicViewController"},
                     @{Tab_Title:@"19、电商类软件加购动画效果",Tab_Url:@"GuoWuCheViewController"},
                     @{Tab_Title:@"20、苹果系统自带分享功能",Tab_Url:@"AppleShareViewController"},
                     @{Tab_Title:@"21、判断手机是否越狱",Tab_Url:@"PrisonBreakViewController"},
                     @{Tab_Title:@"22、倒计时功能",Tab_Url:@"CountDownViewcontroller"},
                     @{Tab_Title:@"23、星级评分功能",Tab_Url:@"StarStarViewController"},
                     @{Tab_Title:@"24、UILabel滚动,类似于跑马灯效果",Tab_Url:@"RollingLightViewController"},
    ];
    [self.tableView reloadData];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArr[indexPath.row][Tab_Title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    BaseViewController *vc = [[NSClassFromString(dic[Tab_Url]) alloc]init];
    vc.navTitle = dic[Tab_Title];
    vc.MyBBLock = ^(NSString * _Nonnull des) {
        KLog(@"MyBBLock --- %@",des);
    };
    vc.name = [NSString stringWithFormat:@"老%ld",indexPath.row+1];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}

- (void)viewDidLayoutSubviews {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark --下拉刷新
- (void)addDropDownRefresh{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新
        [self.tableView.mj_header endRefreshing];
    }];
    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    self.tableView.mj_header = header;
}

#pragma mark -- 上拉加载
- (void)addDropUpRefresh{
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //加载更多方法调用
        [self.tableView.mj_footer endRefreshing];
    }];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing ];
    [footer setTitle:@"松开加载" forState:MJRefreshStatePulling];
    self.tableView.mj_footer = footer;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
