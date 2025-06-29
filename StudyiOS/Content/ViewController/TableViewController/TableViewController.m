//
//  TableViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/3.
//

#import "TableViewController.h"

static NSString * cellID = @"cellID";

@interface TableViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) NSMutableArray *dataArr;//数据源

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUpTableView];
    [self addDropUpRefresh];
    [self addDropDownRefresh];
}

#pragma mark -- 上拉加载
- (void)addDropUpRefresh{
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //加载更多方法调用
        [self.tableView. mj_footer endRefreshing];
    }];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing ];
    [footer setTitle:@"松开加载" forState:MJRefreshStatePulling];
    self.tableView. mj_footer = footer;
}

#pragma mark 下拉刷新
- (void)addDropDownRefresh{
    
#pragma mark 文字加载
    //    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        //下拉刷新
    //        [self.tableView. mj_header endRefreshing];
    //    }];
    //    [header setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    //    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    //    self.tableView. mj_header = header;
    
#pragma mark 动画加载
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //隐藏刷新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //隐藏刷新提示文字
    header.stateLabel.hidden = YES;
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (int i=1; i<9; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"niao_%d.png",i]]];
    }
    NSArray * idleImages = arr;
    [header setImages:idleImages forState:MJRefreshStatePulling];
    self.tableView.mj_header = header;
}

- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
}

- (void)setData{
    for (int i = 0; i<26; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *childTitle = [NSString stringWithFormat:@"%c",i+65];
        dic[@"childTitle"] = childTitle;
        dic[@"childFlag"] = @"0";
        NSMutableArray *childArr = [[NSMutableArray alloc]init];
        for (int j = 0; j<(arc4random_uniform(10)+1); j++) {
            [childArr addObject:KStringWithFormat(@"%@中的第%d条数据",childTitle,j)];
        }
        dic[@"childArr"] = childArr;
        [self.dataArr addObject:dic];
    }
    NSLog(@"%@",self.dataArr);
    NSLog(@"数据本地组装结束!");
}

/** 创建tableview */
- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    int bottom_H = self.name ? -KSafeAreaHeight : -KBottomHeight;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(KTopHeight);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(bottom_H);
    }];
    
    // 改变uitableview中右侧索引的文字颜色、背景颜色
    if (@available(iOS 13.0, *)) {
        self.tableView.sectionIndexColor = [UIColor blackColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
}

/* 组数 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

/* 行数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *childArr = self.dataArr[section][@"childArr"];
    return childArr.count;
}

/* cell显示 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;//必须加上
    
    NSArray *childArr = self.dataArr[indexPath.section][@"childArr"];
    cell.textLabel.text = childArr[indexPath.row];
    return cell;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [DDToast showToast:[NSString stringWithFormat:@"点击了%@中的第%ld条数据",
                        self.dataArr[indexPath.section][@"childTitle"],
                        (long)indexPath.row]];
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *flag = self.dataArr[indexPath.section][@"childFlag"];
    if ([flag isEqualToString:@"1"]){
        return 0;
    }else{
        return 44;
    }
}

/* 组头高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//组头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.tag = section;
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    NSDictionary *childDic = self.dataArr[section];
    NSString *childTitle = childDic[@"childTitle"];
    NSString *childFlag = childDic[@"childFlag"];
    NSArray *childArr = childDic[@"childArr"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenW-60, 30)];
    label.text = KStringWithFormat(@"%@(共%ld条)",childTitle,childArr.count);
    label.backgroundColor = [UIColor clearColor];
    [headView addSubview:label];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenW-35, 7, 16, 16)];
    if ([childFlag isEqualToString:@"0"]) {
        [imageV setImage:[UIImage imageNamed:@"xia"]];
    }else{
        [imageV setImage:[UIImage imageNamed:@"you"]];
    }
    [headView addSubview:imageV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [headView addGestureRecognizer:tap];
    
    return headView;
}

/* 组尾高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//组尾视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}

- (void)sectionClick:(UITapGestureRecognizer *)tap{
    NSUInteger index = tap.view.tag;
    NSString *flag = self.dataArr[index][@"childFlag"];
    if ([flag isEqualToString:@"0"]) {
        self.dataArr[index][@"childFlag"] = @"1";
        NSRange range = NSMakeRange(index, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        self.dataArr[index][@"childFlag"] = @"0";
        NSRange range = NSMakeRange(index, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.tableView reloadData];
}

//右侧索引
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.dataArr) {
        [titleArr addObject:dic[@"childTitle"]];
    }
    return titleArr;
}

//根据索引定位位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSLog(@"===%@  ===%ld",title,index);
    //点击索引 列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

@end
