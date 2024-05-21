//
//  GuoWuCheViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/7.
//

#import "GuoWuCheViewController.h"
#import "ShoppingCartTool.h"

@interface GuoWuCheViewController ()
/** 加入购物车按钮 */
@property (nonatomic, strong) UIButton *addButton;
/** 购物车按钮 */
@property (nonatomic, strong) UIButton *shoppingCartButton;
/** 商品数量label */
@property (nonatomic, strong) UILabel *goodsNumLabel;
/** 商品数量 */
@property (nonatomic, assign) NSInteger num;
@end

@implementation GuoWuCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 0;
    [self setUpUI];
}

- (void)setUpUI {
    // 加入购物车按钮
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width - 120, self.bgView.frame.size.height - 50, 120, 50)];
    [self.bgView addSubview:self.addButton];
    self.addButton.backgroundColor = [UIColor redColor];
    [self.addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 购物车按钮
    self.shoppingCartButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width - 120 - 50 - 20, self.addButton.frame.origin.y, 50, 50)];
    [self.bgView addSubview:self.shoppingCartButton];
    [self.shoppingCartButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [self.shoppingCartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 商品数量label
    self.goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shoppingCartButton.center.x, self.shoppingCartButton.frame.origin.y, 30, 15)];
    [self.bgView addSubview:self.goodsNumLabel];
    self.goodsNumLabel.backgroundColor = [UIColor redColor];
    self.goodsNumLabel.textColor = [UIColor whiteColor];
    self.goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    self.goodsNumLabel.font = [UIFont systemFontOfSize:10];
    self.goodsNumLabel.layer.cornerRadius = 7;
    self.goodsNumLabel.clipsToBounds = YES;
    self.goodsNumLabel.text = @"";
}

/** 加入购物车按钮点击 */
- (void)addButtonClicked:(UIButton *)sender {
    self.num++;
    if(self.num>99){
        self.goodsNumLabel.text = @"99+";
    }else{
        self.goodsNumLabel.text = KStringWithFormat(@"%ld",self.num);
    }
    [ShoppingCartTool addToShoppingCartWithGoodsImage:[UIImage imageNamed:@"xin"] startPoint:self.addButton.center endPoint:self.shoppingCartButton.center completion:^(BOOL finished) {
        //------- 颤抖吧 -------//
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.7];
        scaleAnimation.duration = 0.1;
        scaleAnimation.repeatCount = 2; // 颤抖两次
        scaleAnimation.autoreverses = YES;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.goodsNumLabel.layer addAnimation:scaleAnimation forKey:nil];
    }];
}

@end
