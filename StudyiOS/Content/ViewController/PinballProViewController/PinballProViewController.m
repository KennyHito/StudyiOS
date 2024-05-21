//
//  PinballProViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/3.
//

#import "PinballProViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface PinballProViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic) CMMotionManager *MotionManager;

@end

@implementation PinballProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBalls];
    [self useGyroPush];
}

- (void)setupBalls{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopHeight, KScreenW, KScreenH-KTopHeight-KSafeAreaHeight)];
    [self.view addSubview:bgView];

    
    self.balls = [NSMutableArray array];
    //添加20个球体
    NSUInteger numOfBalls = 20;
    for (NSUInteger i = 0; i < numOfBalls; i ++) {
        
        UIImageView *ball = [UIImageView new];
        
        //球的随机颜色
        ball.image = [UIImage imageNamed:[NSString stringWithFormat:@"headIcon-%ld.jpg",i]];
        
        //球的大小
        CGFloat width = 80;
        ball.layer.cornerRadius = width/2;
        ball.layer.masksToBounds = YES;
        
        //球的随机位置
        CGRect frame = CGRectMake(arc4random()%((int)(bgView.bounds.size.width - width)), 0, width, width);
        [ball setFrame:frame];
        
        //添加球体到父视图
        [bgView addSubview:ball];
        
        //球堆添加该球
        [self.balls addObject:ball];
    }
    //使用拥有重力特性和碰撞特性
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:bgView];
    _animator = animator;
    
    //添加重力的动态特性，使其可执行
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:self.balls];
    [self.animator addBehavior:gravity];
    _gravity = gravity;
    
    //添加碰撞的动态特性，使其可执行
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:self.balls];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    _collision = collision;
    
    //弹性
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.balls];
    dynamicItemBehavior.allowsRotation = YES;//允许旋转
    dynamicItemBehavior.elasticity = 0.6;//弹性
    [self.animator addBehavior:dynamicItemBehavior];
}


- (void)useGyroPush{
    //初始化全局管理对象
    
    self.MotionManager = [[CMMotionManager alloc]init];
    self.MotionManager.deviceMotionUpdateInterval = 0.01;
    
    WS(weakSelf);
    
    [self.MotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *_Nullable motion,NSError * _Nullable error) {
        
        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
        
        //重力角度
        weakSelf.gravity.angle = rotation;
        
        //        NSString *yaw = [NSString stringWithFormat:@"%f",motion.attitude.yaw];
        //        NSString *pitch = [NSString stringWithFormat:@"%f",motion.attitude.pitch];
        //        NSString *roll = [NSString stringWithFormat:@"%f",motion.attitude.roll];
        //NSLog(@"yaw = %@,pitch = %@, roll = %@,rotation = %fd",yaw,pitch,roll,rotation);
        
    }];
    
}

- (void)dealloc{
    [self.MotionManager stopDeviceMotionUpdates];
}

#pragma mark - UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    
}

@end
