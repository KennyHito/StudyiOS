//
//  SecondViewController.m
//  LianChuTest
//
//  Created by vp on 2022/9/29.
//

#import "HomeViewController.h"

#define CellID          @"cellid"

@interface HomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

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
    self.dataArr = [VCControllers getVCController];
    [self.tableView reloadData];
}

#pragma mark -- 增加UI
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
    cell.textLabel.text = KStringWithFormat(@"%ld、%@",indexPath.row+1,self.dataArr[indexPath.row][Tab_Title]);
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
