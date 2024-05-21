//
//  TableViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/3.
//

#import "TableViewController.h"

static NSString * cellID = @"cellID";

@interface TableViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *flagArray;//标识
@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) NSMutableArray *dataArr;//数据源

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUpTableView];
}

- (void)setData{
    for (int i = 0; i<26; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%c",i+65]];
        [self.flagArray addObject:@"0"];
    }
}

/** 创建tableview */
- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, KScreenW, KScreenH) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

/* 组数 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

/* 组尾高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

/* 行数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

/* 组头高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

/* cell显示 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;//必须加上
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@中的第%ld条记录",self.dataArr[indexPath.section],indexPath.row];
    return cell;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [DDToast showToast:[NSString stringWithFormat:@"点击了第%ld组的第%ld个",(long)indexPath.section,(long)indexPath.row]];
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"1"]){
        return 0;
    }else{
        return 44;
    }
}

//组头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.tag = section;
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenW-60, 30)];
    label.text = self.dataArr[section];
    label.backgroundColor = [UIColor clearColor];
    [headView addSubview:label];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenW-30, 5, 20, 20)];
    if ([_flagArray[section] isEqualToString:@"0"]) {
        [imageV setImage:[UIImage imageNamed:@"xia"]];
    }else{
        [imageV setImage:[UIImage imageNamed:@"you"]];
    }
    [headView addSubview:imageV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [headView addGestureRecognizer:tap];
    
    return headView;
}

//组头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}

- (void)sectionClick:(UITapGestureRecognizer *)tap{
    NSUInteger index = tap.view.tag;
    if ([_flagArray[index] isEqualToString:@"0"]) {
        _flagArray[index] = @"1";
        NSRange range = NSMakeRange(index, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        _flagArray[index] = @"0";
        NSRange range = NSMakeRange(index, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//右侧索引
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.dataArr;
}

//根据索引定位位置
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSLog(@"===%@  ===%ld",title,index);
    //点击索引 列表跳转到对应索引的行
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (NSMutableArray *)flagArray{
    if(!_flagArray){
        _flagArray = [[NSMutableArray alloc]init];
    }
    return _flagArray;
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

@end
