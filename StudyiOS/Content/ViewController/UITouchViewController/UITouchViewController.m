//
//  UITouchViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "UITouchViewController.h"

#define IM_W   72*2
#define IM_H   108*2

@interface UITouchViewController ()

@property (nonatomic,strong) UIImageView * imageV;
@property (nonatomic,assign) CGPoint mPtLast;

@end

@implementation UITouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100,IM_W, IM_H)];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:@"https://img1.baidu.com/it/u=999079260,408304605&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=750"]];
    [self.bgView addSubview:_imageV];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    if (touch.tapCount == 1) {
        NSLog(@"单次点击");
    }else if(touch.tapCount == 2){
        NSLog(@"双次点击");
    }
    
    CGPoint pt = [touch locationInView:self.bgView];
    _mPtLast = pt;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint imageVPt = _imageV.frame.origin;
    //    NSLog(@"x = %f,y = %f",imageVPt.x,imageVPt.y);
    //[注意]🐷 : 200 和 300 分别代表imageV的宽和高
    //if语句用来判断,手势是否在图片上进行移动,没有这个判断可以在任何区域进行移动;
    if (_mPtLast.x >= imageVPt.x && _mPtLast.x <= imageVPt.x + 260 && _mPtLast.y >= imageVPt.y && _mPtLast.y <= imageVPt.y + 300) {
        
        UITouch * touch = [touches anyObject];
        CGPoint pt = [touch locationInView:self.bgView];
        NSLog(@"x = %f,y = %f",pt.x,pt.y);
        
        //获得x,y偏移量
        float xOffset = pt.x - _mPtLast.x;
        float yOffset = pt.y - _mPtLast.y;
        
        //必须将最后的位置赋给 _mPtLast
        _mPtLast = pt;
        
        _imageV.frame = CGRectMake(_imageV.frame.origin.x+xOffset, _imageV.frame.origin.y+yOffset, IM_W, IM_H);
    }
    
}

@end
