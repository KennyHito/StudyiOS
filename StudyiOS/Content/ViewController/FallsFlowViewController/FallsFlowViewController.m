//
//  FallsFlowViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "FallsFlowViewController.h"

#define cellID               @"cellID"
#define imageWidth          (KScreenW-20)/3

@interface FallsFlowViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionV;
@property (nonatomic,strong) NSMutableArray *dataArr;//数据源

@end

@implementation FallsFlowViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUpCollectionView];
}

- (void)setData{
    [self.dataArr removeAllObjects];
    for (int i = 0; i < 25; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"美女%02d.jpg",i+1]];
    }
}

- (void)setUpCollectionView{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    flow.itemSize = CGSizeMake(imageWidth, imageWidth);
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH) collectionViewLayout:flow];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    _collectionV.showsVerticalScrollIndicator = NO;
    _collectionV.showsHorizontalScrollIndicator = NO;
    [_collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:_collectionV];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    iv.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
    [cell.contentView addSubview:iv];
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame)-20, CGRectGetWidth(iv.frame), 20)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = [UIColor redColor];
    titleLab.text = self.dataArr[indexPath.row];
    [cell.contentView addSubview:titleLab];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [DDToast showToast:KStringWithFormat(@"你点击的是%ld个",indexPath.row+1)];
}

@end
