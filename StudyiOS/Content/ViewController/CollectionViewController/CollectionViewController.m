//
//  CollectionViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/30.
//

#import "CollectionViewController.h"
#import "CustomFlowLayout.h"
#import "CustomCollectionViewCell.h"
#import "VipCardViewController.h"

#define ZiHao       16
#define CELLID      @"CustomCollectionViewCell"

@interface CollectionViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,strong)UICollectionView *collectionV;
@property (nonatomic,strong)CustomFlowLayout *cFlowLayout;
@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"发展",@"是人类",@"社会的",@"永恒主题",@"共享",@"发展",@"是",@"建设",@"美好世界",@"的",@"重要路径",@"作为",@"最大的",@"发展中国家",@"中国",@"始终",@"将自身发展",@"置于人类发展的坐标系",@"以自身发展",@"为世界发展",@"创造新机遇",@"在过去的10年里",@"中国经济",@"总量占全球比重",@"由2012年的11.3%",@"提升到2022年的18%左右",@"对世界",@"经济增长",@"年平均贡献率超过30%",@"始终是",@"世界经济",@"稳定增长",@"重要动力源",@"今日之中国",@"是全球",@"第一货物贸易大国",@"140多个国家",@"和地区",@"主要贸易伙伴",@"吸引外资",@"对外投资居",@"世界前列",@"为各国",@"提供了",@"更多市场机遇",@"投资机遇",@"增长机遇",@"发展",@"是人类",@"社会的",@"永恒主题",@"共享",@"发展",@"是",@"建设",@"美好世界",@"的",@"重要路径",@"作为",@"最大的",@"发展中国家",@"中国",@"始终",@"将自身发展",@"置于人类发展的坐标系",@"以自身发展",@"为世界发展",@"创造新机遇",@"在过去的10年里",@"中国经济",@"总量占全球比重",@"由2012年的11.3%",@"提升到2022年的18%左右",@"对世界",@"经济增长",@"年平均贡献率超过30%",@"始终是",@"世界经济",@"稳定增长",@"重要动力源",@"今日之中国",@"是全球",@"第一货物贸易大国",@"140多个国家",@"和地区",@"主要贸易伙伴",@"吸引外资",@"对外投资居",@"世界前列",@"为各国",@"提供了",@"更多市场机遇",@"投资机遇",@"增长机遇"];
    [self.view addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    [cell.btn setTitle:self.dataArr[indexPath.row] forState:UIControlStateNormal];
    cell.btn.titleLabel.font = [UIFont systemFontOfSize:ZiHao];
    cell.btn.userInteractionEnabled = NO;
    return cell;
}

// 给每一个Item设置独立的Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 10;
    CGFloat H = 30;
    CGRect itemFrame = [[self.dataArr objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(KScreenW, H) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:ZiHao]} context:nil];
    CGFloat W = itemFrame.size.width + margin;
    return CGSizeMake(W, H);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [DDToast showToast:self.dataArr[indexPath.row]];
    VipCardViewController *vc = [[VipCardViewController alloc] init];
    vc.title = @"哈哈哈";
    vc.block1 = ^(NSString * _Nonnull name) {
        KLog(@"1---->%@",name);
    };
    vc.MyBBLock = ^(NSString * _Nonnull des) {
        KLog(@"2---->%@",des);
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionV{
    if(!_collectionV){
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.cFlowLayout];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        [_collectionV registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    }
    return _collectionV;
}

- (CustomFlowLayout *)cFlowLayout{
    if(!_cFlowLayout){
        _cFlowLayout = [[CustomFlowLayout alloc] init];
        // item 布局属性设置
        _cFlowLayout.left = 10;
    }
    return _cFlowLayout;
}

- (NSArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}
@end
