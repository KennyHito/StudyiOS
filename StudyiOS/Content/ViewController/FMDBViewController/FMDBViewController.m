//
//  FMDBViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/22.
//

#import "FMDBViewController.h"
#import "FMDBModel.h"

@interface FMDBViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong)UITableView *tableView;//列表
@property (nonatomic,strong)NSMutableArray *dataArr;//数据源

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self initData];
}

- (void)initData{
    [self.dataArr removeAllObjects];
    NSArray *dicArr = @[@{@"id":@"1",@"stuAge":@"19",@"stuHeight":@"173",@"stuName":@"张三"},
                        @{@"id":@"2",@"stuAge":@"18",@"stuHeight":@"183",@"stuName":@"李四"},
                        @{@"id":@"3",@"stuAge":@"19",@"stuHeight":@"163",@"stuName":@"王五"},
                        @{@"id":@"4",@"stuAge":@"20",@"stuHeight":@"170",@"stuName":@"麻六"}];
    for (NSDictionary *dic in dicArr) {
        [self.dataArr addObject:[FMDBModel mj_objectWithKeyValues:dic]];
    }
    [self reloadTableView];
}


#pragma mark 创建tableview
- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgView);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

/* cell内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    FMDBModel * user = self.dataArr[indexPath.row];
    cell.textLabel.text = user.stuName;

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(KScreenW-180, 0, 100, CGRectGetHeight(cell.bounds))];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:label];
    
    UISwitch * sw = [[UISwitch alloc]initWithFrame:CGRectMake(50, 50, 100, 50)];
    sw.on = NO;//默认关闭状态
    label.text = @"未收藏";
    sw.tag = [user.ID integerValue];
    if ([[SQliteManager defaultSqliteManager] isExsitMenuWithID:user.ID]) {
        sw.on = YES;
        label.text = @"已收藏";
    }
    [sw addTarget:self action:@selector(changeEvent:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    
    return cell;
}

#pragma mark -- UISwitch开关按钮事件实现
- (void)changeEvent:(UISwitch *)sw{
    NSString * strTag = [NSString stringWithFormat:@"%ld",sw.tag];
    if (sw.on) {
        //开启
        [[SQliteManager defaultSqliteManager] menuWithID:strTag];
    }else{
        //关闭
        [[SQliteManager defaultSqliteManager] deleteMenuWithID:strTag];
    }
    [self reloadTableView];
}

/* 刷新数据 */
- (void)reloadTableView{
    [self.tableView reloadData];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
