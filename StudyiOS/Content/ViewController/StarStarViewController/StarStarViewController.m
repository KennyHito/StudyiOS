//
//  StarStarViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/19.
//

#import "StarStarViewController.h"

@interface StarStarViewController ()<starStarDelegate>

@end

@implementation StarStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * lab = [self createLabelTitle:@"你没有评论呢?" andFont:15 andTitleColor:[UIColor blackColor] andBackColor:[UIColor whiteColor] andTag:100 andFrame:CGRectMake(10, 120,KScreenW-20, 30) andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lab];
    
    starView * star = [[starView alloc]initWithFrame:CGRectMake(30, 150,  KScreenW-60, 70)];
    star.delegate = self;
    [self.view addSubview:star];
    
    [star setScore:0 withAnimation:YES completion:^(BOOL finished) {
        NSLog(@"这里可以设置相关的内容");
    }];
}

//代理方法
- (void)starRatingViewScore:(float)score{
    UILabel *lab = [self.view viewWithTag:100];
    lab.text = [NSString stringWithFormat:@"%0.1f分", score * 5];
}

- (UILabel *)createLabelTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackColor:(UIColor *)backColor andTag:(int)tag andFrame:(CGRect)frame andTextAlignment:(NSTextAlignment)align{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    if (size==0) {
        label.adjustsFontSizeToFitWidth = YES;
    }else{
        label.font = [UIFont systemFontOfSize:size];
    }
    label.textColor = titleColor;
    label.backgroundColor = backColor;
    label.tag = tag;
    label.textAlignment = align;
    return label;
}
@end
