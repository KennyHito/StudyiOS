### 一、采用Objective-C开发语言, 此Demo包含以下功能, 欢迎大家使用。
#### 若在使用过程中有问题可以在提到[issues](https://github.com/KennyHito/StudyiOS/issues) ,我将尽量为你解答。

~~~
1、使用定时器注意事项; 
2、实时学习; 
3、ReactiveObjC; 
4、切换App Logo; 
5、测试崩溃一下; 
6、多线程NSThread、GCD和NSOperation; 
7、Runtime; 
8、CollectionView自定义标签; 
9、关于我们; 
10、TableView展开收起; 
11、截图分享功能; 
12、弹球碰撞功能; 
13、设置九宫格密码; 
14、日期选择器; 
15、HTML5交互; 
16、仿京东地址选择器; 
17、AVPlayer播放视频; 
18、AVPlayer播放音频; 
19、电商类软件加购动画效果; 
20、苹果系统自带分享功能; 
21、判断手机是否越狱; 
22、倒计时功能; 
23、星级评分功能; 
24、UILabel滚动,类似于跑马灯效果; 
25、图片保存功能; 
26、网络请求功能; 
27、实现本地通知功能; 
28、原生扫描二维码功能; 
29、UITouch移动图片位置; 
30、标签选择功能; 
31、实现瀑布流功能; 
32、调用闪光灯功能; 
33、系统自带定位功能; 
34、轮播新闻类功能; 
35、实现FMDB库功能; 
36、Masonry库的使用; 
37、类似vip会员样式;
~~~

### 二、列举几个功能
#### 1、YYKeyChainData

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

<p align = "center"> 
<img src="https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_1.png" alt="图一">
</p>


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

<p align = "center"> 
<img src="https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/YYKeyChainData_2.png" alt="图二">
</p>

无论你怎么折腾都会保证同一设备每次获取到的UUID都是一致的，卸载应用，开启广告限制跟踪，系统升级都不会有影响。越狱刷机这种骚操作我没有测过，即使有问题，感觉这些调皮的用户也可以忽略了，因为这个已经是目前最好的解决办法了，如果大家有什么更好的解决方案，还请issues区指正。

#### 2、动态更改APP图标

iOS 10.3 加入了了更换应用图标的新功能，开发者可以为应用提供多个应用图标选择。用户可以自由的在这些图标之间切换，下面具体查看切换步骤。
实现方法:

2.1、先把你需要的所有图片都导入项目中（比例为1:1）

<p align = "center"> 
<img src="https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/changeLogo_1.png" alt="图二">
</p>

2.2、plist文件配置，添加Icon files (ios 5)类型为Dictionary
点开Icon files (iOS 5)，里面有Primary Icon，Newsstand Icon两个key,Primary Icon 里面的图片为AppIcon默认图片。
Icon files (iOS 5)里面创建一个CFBundleAlternateIcons，类型为Dictionary
点击开CFBundleAlternateIcons，添加CFBundleIconFiles,按照如图所示的添加，我添加了三个分别是 Icon1，Icon2（这个名字是自己写的），它们对应的本地图片名字是Icon1,Icon2,添加时数据类型对应一致就OK.

<p align = "center"> 
<img src="https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/changeLogo_2.png" alt="图二">
</p>


2.3、执行代码

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

#### 3、小球碰撞球功能

3.1、首先,需要学习一些知识点

a.CoreMotion框架(加速计和陀螺仪)
* [http://blog.csdn.net/sifenkesi1/article/details/52621873](http://blog.csdn.net/sifenkesi1/article/details/52621873);
* [http://justsee.iteye.com/blog/1933099](http://justsee.iteye.com/blog/1933099);

b.UIDynamicAnimator - 仿真物理学
* [http://www.jianshu.com/p/8aa3525f8d48](http://www.jianshu.com/p/8aa3525f8d48);
* [http://www.cnblogs.com/pengsi/p/5798312.html](http://www.cnblogs.com/pengsi/p/5798312.html);
* [http://blog.csdn.net/lengshengren/article/details/12000649](http://blog.csdn.net/lengshengren/article/details/12000649);
* [http://blog.csdn.net/sharktoping/article/details/52277158](http://blog.csdn.net/sharktoping/article/details/52277158);


3.2、代码如下

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


#### 4、实现本地推送

4.1、功能部分:</br>

<p align = "center"> 
<img src="https://github.com/KennyHito/StudyiOS/blob/main/StudyiOS/Resource/Images/tuisong_1.webp" alt="本地推送分析图">
</p>

4.2、iOS8本地推送注册
~~~
//创建本地通知
- (void)requestAuthor
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}
~~~

~~~
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //本地推送
    [self requestAuthor];
    return YES;
}
~~~

4.3、假设在ViewController中添加touchesBegan方法,具体UILocalNotification的基本属性请往下看!
~~~
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1.创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 2.设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = @"本地通知测试";
    // 设置通知的发送时间,单位秒
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    //解锁滑动时的事件
    localNotification.alertAction = @"别磨蹭了!";
    //收到通知时App icon的角标
    localNotification.applicationIconBadgeNumber = 1;
    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 3.发送通知(🐽 : 根据项目需要使用)
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // 方式二: 立即发送通知
    // [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
~~~

##### 注意:UILocalNotification的基本属性
~~~
fireDate：启动时间
timeZone：启动时间参考的时区
repeatInterval：重复推送时间（NSCalendarUnit类型），0代表不重复
repeatCalendar：重复推送时间（NSCalendar类型）
alertBody：通知内容
alertAction：解锁滑动时的事件
alertLaunchImage：启动图片，设置此字段点击通知时会显示该图片
alertTitle：通知标题，适用iOS8.2之后
applicationIconBadgeNumber：收到通知时App icon的角标
soundName：推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
userInfo：发送通知时附加的内容
category：此属性和注册通知类型时有关联，（有兴趣的同学自己了解，不详细叙述）适用iOS8.0之后

region：带有定位的推送相关属性，具体使用见下面【带有定位的本地推送】适用iOS8.0之后
regionTriggersOnce：带有定位的推送相关属性，具体使用见下面【带有定位的本地推送】适用iOS8.0之后
~~~

4.4、注意一点. 当再次进入app中,通知栏的通知需要不显示,并且app的角标也要没有,所以需要在appDelegate设置一个属性.
~~~
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //设置应用程序图片右上角的数字(如果想要取消右上角的数字, 直接把这个参数值为0)
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
~~~


4.5、运行效果图   
 - 注意: 运行程序后,点击ViewController空白区域之后,必须推到后台才能看到通知的运行效果.
- 首次运行会弹出让用户选择授权!!!

<p align = "center"> 
<img src="https://raw.githubusercontent.com/KennyHito/StudyiOS/main/StudyiOS/Resource/Images/tuisong_2.webp" alt="首次运行会弹出让用户选择授权" width="365" height="278">
</p>

<p align = "center"> 
<img src="https://raw.githubusercontent.com/KennyHito/StudyiOS/main/StudyiOS/Resource/Images/tuisong_3.webp" alt="在桌面顶部弹出效果"  width="375" height="667">
</p>
