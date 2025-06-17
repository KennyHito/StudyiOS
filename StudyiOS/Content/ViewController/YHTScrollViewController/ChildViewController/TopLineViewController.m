//
//  TopLineViewController.m
//
//  Created by KennyHito on 16/7/18.
//  Copyright © 2016年 sun. All rights reserved.
//

#import "TopLineViewController.h"
#import "MenuModel.h"
#import "showViewController.h"


@interface TopLineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation TopLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _dataArr = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-264-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //注册cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    
    [self.view addSubview:_tableView];
    
    [self createRequest];
}

- (void)createRequest{
    [self.dataArr removeAllObjects];
    [HttpCommonRequest requestByGetWithUrl:Request_Api_1 param:nil success:^(id _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"] intValue] == 200) {
            [self.dataArr addObject:[MenuModel mj_objectWithKeyValues:dic[@"data"]]];
            [self.tableView reloadData];
        }else{
            [DDToast showToast:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [DDToast showToast:error.localizedDescription];
    }];
}

#pragma mark -- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    MenuModel * model = self.dataArr[indexPath.row];
    
    cell.textLabel.text = model.content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    showViewController * showVC = [[showViewController alloc]init];
    [showVC sendDataArr:self.dataArr[indexPath.row]];
    [self.navigationController pushViewController:showVC animated:YES];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
