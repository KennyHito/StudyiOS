//
//  TagSelectViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "TagSelectViewController.h"
#import "TagModel.h"

static NSString * cellID = @"cellID";

@interface TagSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) NSMutableArray * titleArr;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * allArr;//全部标签
@property (nonatomic,strong) NSMutableArray * meArr;//我的标签

@end

@implementation TagSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = [NSMutableArray arrayWithArray:@[@"我的标签",@"全部标签"]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setData];
    [self setCollectionView];
}

//初始化数据
- (void)setData{
    _dataArr = [[NSMutableArray alloc]init];
    _meArr = [[NSMutableArray alloc]init];
#if 0
    _allArr = [[NSMutableArray alloc]init];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"tagsData" ofType:@"plist"];
    NSArray * arr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary * dic in arr) {
        TagModel * model = [[TagModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.allArr addObject:model];
    }
    [self.dataArr addObjectsFromArray:@[self.meArr,self.allArr]];
#else
    _allArr = [[NSMutableArray alloc]initWithObjects:@"Java",@"C",@"C++",@"C#",@"PHP",@"Python",@"VB",@"JavaScript",@"SQL",@"Ruby",@"Objective-C",@"Perl",@".NET",@"VF",@"R语言",@"Swift", nil];
    [self.dataArr addObject:_meArr];
    [self.dataArr addObject:_allArr];
#endif
}

//创建CollectionView
- (void)setCollectionView{
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.minimumLineSpacing = 5;
    layOut.minimumInteritemSpacing = 5;
    layOut.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 30); //设置collectionView头视图的大小
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10,KScreenW-20, KScreenH-20) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    //注册头视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark -------------------UICollectionDelegate----------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * arr = self.dataArr[section];
    return arr.count;
}

//cell内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    // 防止复用
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }

    UILabel * lab = [[UILabel alloc]init];
    lab.layer.borderWidth = 1;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor whiteColor];
#if 0
    TagModel * model = self.dataArr[indexPath.section][indexPath.row];
    lab.layer.borderColor = [self colorWithHexadecimal:model.color].CGColor;
    lab.textColor = [self colorWithHexadecimal:model.color];
    lab.text = model.title;
#else
    lab.text = self.dataArr[indexPath.section][indexPath.row];
    lab.textColor = RandomColor;
    lab.layer.borderColor = lab.textColor.CGColor;
#endif
    CGSize size = [self widthForLabel:lab.text fontSize:16];
    lab.frame = CGRectMake(0, 0,size.width+10, 21);
    [cell addSubview:lab];
    
    return cell;
}

//cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
#if 0
    TagModel *model = self.dataArr[indexPath.section][indexPath.row];
    CGFloat width = [self widthForLabel:model.title fontSize:16].width;
#else
    NSString * title = self.dataArr[indexPath.section][indexPath.row];
    CGFloat width = [self widthForLabel:title fontSize:16].width;
    return CGSizeMake(width+10,32);
#endif
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 0, 100, header.bounds.size.height);
        lab.text = _titleArr[indexPath.section];
        lab.textColor = [UIColor blackColor];
        lab.backgroundColor = [UIColor whiteColor];
        [header addSubview:lab];
        
        if (indexPath.section==0) {
            UITextField *tf = [[UITextField alloc] init];
            tf.frame = CGRectMake(CGRectGetMaxX(lab.frame), 2, KScreenW-200, 25);
            tf.borderStyle = UITextBorderStyleRoundedRect;
            tf.placeholder = @"请输入标签";
            tf.tag = 1000;
            [header addSubview:tf];
            
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(CGRectGetMaxX(tf.frame)+10, 2, 50, 25);
            [btn setTitle:@"添加" forState:UIControlStateNormal];
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [UIColor grayColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:btn];
        }
        
        return header;
        
    } else {
        return nil;
    }
}
- (void)btnClick:(UIButton *)btn{
    UITextField * tf = (UITextField *)[self.view viewWithTag:1000];
    if ([tf.text isEqualToString:@""]) {
        [DDToast showToast:@"输入框不能为空!"];
        return;
    }
    [self.meArr addObject:tf.text];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld组===第%ld个",indexPath.section,indexPath.row);
    
    if (indexPath.section == 0) {
        [self.allArr addObject:self.meArr[indexPath.row]];
        [self.meArr removeObjectAtIndex:indexPath.row];
    }else{
        [self.meArr addObject:self.allArr[indexPath.row]];
        [self.allArr removeObjectAtIndex:indexPath.row];
    }
    [collectionView reloadData];
}

/* 计算文字宽度 */
- (CGSize)widthForLabel:(NSString *)text fontSize:(CGFloat)font{
    
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size;
}

//十六进制转颜色
- (UIColor *)colorWithHexadecimal:(NSString *)hexCode{
    NSString *cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
