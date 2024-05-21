//
//  ChangeLogoViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import "ChangeLogoViewController.h"

static NSString * cellID = @"cellID";
static int imageWidth = 100;

@interface ChangeLogoViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;//数据源
@property (nonatomic,strong) UICollectionView * collectionV;

@end

@implementation ChangeLogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);;
    [self setData];
    [self setUpCollectionView];
}

- (void)setData{
    [self.dataArr removeAllObjects];
    [self.dataArr addObject:@{@"iconName":@"moren",@"imageName":@"moren.jpg"}];
    [self.dataArr addObject:@{@"iconName":@"dangdang",@"imageName":@"dangdang.png"}];
    [self.dataArr addObject:@{@"iconName":@"chubaobao",@"imageName":@"chubaobao.png"}];
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    flow.itemSize = CGSizeMake(imageWidth, imageWidth);
    
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    self.collectionV.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.collectionV.dataSource = self;
    self.collectionV.delegate = self;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    [self.collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.bgView addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    
    UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    iv.layer.cornerRadius = 10;
    iv.layer.masksToBounds = YES;
    iv.image = [UIImage imageNamed:dict[@"imageName"]];
    [cell.contentView addSubview:iv];

    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame)+5, CGRectGetWidth(iv.frame), 20)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.backgroundColor = [UIColor yellowColor];
    titleLab.textColor = [UIColor redColor];
    titleLab.text = @"设置Logo";
    titleLab.layer.cornerRadius = 10;
    titleLab.layer.masksToBounds = YES;
    [cell.contentView addSubview:titleLab];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    if([dict[@"iconName"] isEqualToString:@"moren"]){
        [self setIconName:nil];
    }else{
        [self setIconName:dict[@"iconName"]];
    }
}

- (void)setIconName:(NSString *)name {
    UIApplication *application = [UIApplication sharedApplication];
    //先判断设备支不支持“AlternateIcons”
    if (@available(iOS 10.3, *)) {
        if ([application supportsAlternateIcons]) {
            //这里的IconName必须在Info.plist里定义，具体格式看Info.plist
            [application setAlternateIconName:name completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    [DDToast showToast:error.localizedDescription];
                }
            }];
        }
    } else {
        // Fallback on earlier versions
        [DDToast showToast:@"系统不支持,最低支持系统为10.3"];
    }
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
