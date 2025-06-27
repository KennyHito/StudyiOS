//
//  CollectionViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/30.
//

#import "CollectionViewController.h"
#import "CustomFlowLayout.h"
#import "CustomCollectionViewCell.h"
#import "ExerciseViewController.h"

#define FONTSIZE       16
#define CELLID          @"CustomCollectionViewCell"

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
    self.dataArr = @[@"科技感", @"创新", @"研发", @"突破",@"教育", @"培训", @"学习",@"知识",@"健康", @"医疗", @"保健", @"养生",@"环保", @"绿化带", @"低碳", @"可持续",@"文化", @"艺术", @"历史", @"传承",@"经济", @"金融只是", @"投资", @"贸易",@"旅游", @"观光", @"风景", @"体验",@"美食", @"烹饪", @"食材", @"口味",@"运动", @"健身方案", @"锻炼", @"活力",@"娱乐", @"休闲区", @"游戏", @"放松",@"社交", @"交流", @"互动", @"人脉",@"职场规划", @"工作", @"职业", @"发展",@"家庭", @"亲情游戏", @"关爱", @"温暖",@"情感", @"爱情", @"友情", @"心情",@"时尚", @"潮流", @"风格", @"个性",@"数码", @"电子游戏", @"智能", @"科技",@"汽车", @"交通", @"驾驶", @"安全",@"房产", @"住房", @"装修", @"社区",@"音乐", @"歌曲", @"演奏", @"欣赏",@"电影", @"影视", @"剧情", @"cosplay角色",@"书籍", @"阅读", @"知识渊博", @"思想",@"摄影摄像", @"照片", @"画面", @"美感",@"旅行", @"旅途", @"目的地", @"记忆",@"宠物", @"动物世界", @"陪伴", @"照顾",@"农业发展", @"种植技术", @"养殖", @"丰收之年",@"工业", @"制造", @"生产", @"效率",@"商业", @"企业", @"销售", @"利润",@"政府", @"政策", @"服务", @"管理",@"公益事业", @"志愿", @"帮助", @"奉献精神",@"自然", @"生态", @"环境", @"保护",@"宇宙", @"星空", @"探索", @"奥秘"];
    [self.view addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.bottom.mas_equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    [cell.btn setTitle:self.dataArr[indexPath.row] forState:UIControlStateNormal];
    cell.btn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    //去掉可交互性,走的collectionView的didSelectItemAtIndexPath方法
    cell.btn.userInteractionEnabled = NO;
    return cell;
}

// 给每一个Item设置独立的Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 10;
    CGFloat H = 30;
    CGRect itemFrame = [[self.dataArr objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(KScreenW-20, H) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONTSIZE]} context:nil];
    CGFloat W = itemFrame.size.width + margin;
    return CGSizeMake(W, H);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [DDToast showToast:self.dataArr[indexPath.row]];
    
    ExerciseViewController *vc = [[ExerciseViewController alloc] init];
    vc.money = 99;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionV{
    if(!_collectionV){
        _collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.cFlowLayout];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.showsVerticalScrollIndicator = NO;
        _collectionV.showsHorizontalScrollIndicator = NO;
        [_collectionV registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    }
    return _collectionV;
}

- (CustomFlowLayout *)cFlowLayout{
    if(!_cFlowLayout){
        _cFlowLayout = [[CustomFlowLayout alloc] init];
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
