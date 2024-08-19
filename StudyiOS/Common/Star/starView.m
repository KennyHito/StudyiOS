//
//  starView.m
//  StarStar
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

/*
 类似于淘宝评价中----星星好评
 ★★★★★  五星好评
 ★★★★   四星好评
 ★★★    三星中评
 ★★     二星中评
 ★      一星差评
 */

#import "starView.h"


// define
#define Star_Number 5

@interface starView()

@property (nonatomic, strong) UIView *starBackgroundView;//星星背景色
@property (nonatomic, strong) UIView *starForegroundView;//星星前景色
@property (nonatomic, assign) int numberOfStar;//星星数量

@end


@implementation starView

// 构造函数
- (instancetype)initWithFrame:(CGRect)frame{
    return  [self initWithFrame:frame withNumbers:Star_Number];
}

/*
 frame : 大小
 number : 星星个数,默认5个
 */

- (instancetype)initWithFrame:(CGRect)frame withNumbers:(int)number{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.starBackgroundView = [self buidlStarViewWithImageName:@"star_gray"];
    self.starForegroundView = [self buidlStarViewWithImageName:@"star_yellow"];
    self.starForegroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}


- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL))completion{
    //断言 如果不满足条件会打印score must be between 0 and 1
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0){
        score = 0;
    }
    
    if (score > 1){
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        __weak typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [weakSelf changeStarForegroundViewWithPoint:point];
            
        } completion:^(BOOL finished){
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

/**
 *  通过图片构建星星视图
 *  @param imageName 图片名称
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}


/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point{
    
    CGPoint p = point;
    if (p.x < 0){
        p.x = 0;
    }
    if (p.x > self.frame.size.width){
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingViewScore:)]){
        [self.delegate starRatingViewScore:score];
    }
}


#pragma mark 
#pragma mark --- 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //判断给定的点是否被一个CGRect包含,可以用CGRectContainsPoint函数
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)){
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf changeStarForegroundViewWithPoint:point];
    }];
}

@end
