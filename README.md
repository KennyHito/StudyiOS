# StudyiOS
oc综合项目,ios综合项目,拖拽播放,打印ios日志,省市区三级联动,YYText使用,列表的展开和收起,Masonry案例,倒计时,H5和原生交互,自定义各种弹框…


#### 一、YYKeyChainData

获取UUID的方法有很多，但是都会因为各种原因改变
```
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *UUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return UUID;
}
 
/**  卸载应用重新安装后会不一致*/
+ (NSString *)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}
 
/** 不会因为应用卸载改变 
  * 但是用户在设置-隐私-广告里面限制广告跟踪后会变成@"00000000-0000-0000-0000-000000000000"
  * 重新打开后会变成另一个，还原广告标识符也会变
  */
+ (NSString *)getUUID{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}
```

作为设备唯一的标识符，一言不合就变了肯定是不行的呀

在产品汪的逼迫下，在我不懈的努力下，我终于找到一个可以一直保持一致的方法。第一次获取成功后保存到钥匙串，然后每次使用都通过钥匙串去拿。

第一步,打开应用的钥匙串权限
Target - Capabilities - KeychainSharing - ON
![图一](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_1.png)

第二步,集成YYKeyChainData

导入头文件
```
#import "YYKeyChainData.h"
```
类方法调用即可使用
```
[YYKeyChainData getUUIDByKeyChain]
```

注意:
上架App Store需要按图二配置
![图二](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_2.png)


无论你怎么折腾都会保证同一设备每次获取到的UUID都是一致的，卸载应用，开启广告限制跟踪，系统升级都不会有影响。越狱刷机这种骚操作我没有测过，即使有问题，感觉这些调皮的用户也可以忽略了，因为这个已经是目前最好的解决办法了，如果大家有什么更好的解决方案，还请issues区指正。

#### 二、动态更改APP图标

iOS 10.3 加入了了更换应用图标的新功能，开发者可以为应用提供多个应用图标选择。用户可以自由的在这些图标之间切换，下面具体查看切换步骤。
实现方法:

1.先把你需要的所有图片都导入项目中（比例为1:1）

![图一](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/changeLogo_1.png)

2.plist文件配置，添加Icon files (ios 5)类型为Dictionary
点开Icon files (iOS 5)，里面有Primary Icon，Newsstand Icon两个key,Primary Icon 里面的图片为AppIcon默认图片。
Icon files (iOS 5)里面创建一个CFBundleAlternateIcons，类型为Dictionary
点击开CFBundleAlternateIcons，添加CFBundleIconFiles,按照如图所示的添加，我添加了三个分别是 Icon1，Icon2（这个名字是自己写的），它们对应的本地图片名字是Icon1,Icon2,添加时数据类型对应一致就OK.

![图二](https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/changeLogo_2.png)

3.执行代码

~~~
- (IBAction)setIconClick:(UIButton *)sender {
    [self setIconName:nil];//nil表示换回原始Icon
}

- (IBAction)setIcon1Click:(id)sender {
    [self setIconName:@"Icon1"];
}

- (IBAction)setIcon2Click:(id)sender {
    [self setIconName:@"Icon2"];
}

- (void)setIconName:(NSString *)name {
UIApplication *application = [UIApplication sharedApplication];
//先判断设备支不支持“AlternateIcons”
if ([application supportsAlternateIcons]) {
//这里的IconName必须在Info.plist里定义，具体格式看Info.plist
    [application setAlternateIconName:name completionHandler:^(NSError * _Nullable error) {
    if (error) {
        NSLog(@"error => %@", error.localizedDescription);
    } else {
        NSLog(@"done!");
    }
  }];
}
}
~~~

#### 三、小球碰撞球功能

1.首先,需要学习一些知识点

1.1.CoreMotion框架(加速计和陀螺仪)
* [http://blog.csdn.net/sifenkesi1/article/details/52621873](http://blog.csdn.net/sifenkesi1/article/details/52621873);
* [http://justsee.iteye.com/blog/1933099](http://justsee.iteye.com/blog/1933099);

1.2.UIDynamicAnimator - 仿真物理学
* [http://www.jianshu.com/p/8aa3525f8d48](http://www.jianshu.com/p/8aa3525f8d48);
* [http://www.cnblogs.com/pengsi/p/5798312.html](http://www.cnblogs.com/pengsi/p/5798312.html);
* [http://blog.csdn.net/lengshengren/article/details/12000649](http://blog.csdn.net/lengshengren/article/details/12000649);
* [http://blog.csdn.net/sharktoping/article/details/52277158](http://blog.csdn.net/sharktoping/article/details/52277158);


2.代码如下

~~~
- (void)setupBalls{

self.balls = [NSMutableArray array];
//添加20个球体
NSUInteger numOfBalls = 20;
for (NSUInteger i = 0; i < numOfBalls; i ++) {

UIImageView *ball = [UIImageView new];

//球的随机颜色
ball.image = [UIImage imageNamed:[NSString stringWithFormat:@"headIcon-%ld.jpg",i]];

//球的大小
CGFloat width = 40;
ball.layer.cornerRadius = width/2;
ball.layer.masksToBounds = YES;

//球的随机位置
CGRect frame = CGRectMake(arc4random()%((int)(self.view.bounds.size.width - width)), 0, width, width);
[ball setFrame:frame];

//添加球体到父视图
[self.view addSubview:ball];

//球堆添加该球
[self.balls addObject:ball];
}
//使用拥有重力特性和碰撞特性
UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
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
~~~

~~~
- (void)useGyroPush{
//初始化全局管理对象

self.MotionManager = [[CMMotionManager alloc]init];
self.MotionManager.deviceMotionUpdateInterval = 0.01;

__weak ViewController *weakSelf = self;

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
~~~
