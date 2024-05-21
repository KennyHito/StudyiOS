//
//  Contast.h
//  LianChuTest
//
//  Created by vp on 2022/9/29.
//

#ifndef Contast_h
#define Contast_h

/***************************系统版本*****************************/
//获取手机系统的版本
#define KSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//是否为iOS7及以上系统
#define KiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//是否为iOS8及以上系统
#define KiOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
//是否为iOS9及以上系统
#define KiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
//是否为iOS10及以上系统
#define KiOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
//是否为iOS11及以上系统
#define KiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
//是否为iOS12及以上系统
#define KiOS12 ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)

/***************************沙盒路径*****************************/
//沙盒路径
#define KHomePath NSHomeDirectory()
//获取沙盒 Document
#define KPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define KPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 temp
#define KPathTemp NSTemporaryDirectory()

/***************************打印日志*****************************/
/// 日志打印
#ifdef DEBUG
#define KLog(format, ...) do {\
fprintf(stderr, "<%s : %d行> %s\n",\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__, __func__);\
printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);\
fprintf(stderr, "---------------------------------------------------------------\n");\
} while (0)
#else
#define KLog(format, ...) nil
#endif

/***************************系统高度*****************************/
//屏幕的宽高
#define KScreenW                [UIScreen mainScreen].bounds.size.width
#define KScreenH                [UIScreen mainScreen].bounds.size.height
//屏幕大小
#define KScreenRect             [UIScreen mainScreen].bounds
#define KScreenSize             [UIScreen mainScreen].bounds.size
//比例宽和高(以6s为除数)
#define KActureHeight(height)   roundf(height/375.0 * KScreenW)
#define KActureWidth(Width)     roundf(Width/667.0 * KScreenH)

//顶部状态栏的高度
#define KStatusBarHeight        [[UIApplication sharedApplication] statusBarFrame].size.height
//顶部导航栏的高度
#define KNavBarHeight           44.0
//顶部状态栏+顶部导航栏的高度
#define KTopHeight              (KStatusBarHeight + KNavBarHeight)

//底部安全区的高度
#define KSafeAreaHeight         (KStatusBarHeight > 20 ? 34 : 0)
//底部tab栏高度
#define KTabBarHeight           49.0
//底部安全区+底部tab栏的高度
#define KBottomHeight           (KSafeAreaHeight+KTabBarHeight)

/***************************视图,类初始化*****************************/
//获取视图宽高XY等信息
#define KviewH(view1)           view1.frame.size.height
#define KviewW(view1)           view1.frame.size.width
#define KviewX(view1)           view1.frame.origin.x
#define KviewY(view1)           view1.frame.origin.y
//获取self.view的宽高
#define KSelfViewW              (self.view.frame.size.width)
#define KSelfViewH              (self.view.frame.size.height)
///实例化
#define KViewAlloc(view,x,y,w,h) [[view alloc]initWithFrame:CGRectMake(x, y, w, h)]
#define KAllocInit(Controller,cName) Controller *cName = [[Controller alloc]init]

//View圆角和加边框
#define KViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define KViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//View分割线
#define KViewLine(X,Y,W,H)\
UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(X,Y,W,H)];\
lineView.backgroundColor = LineColor;

//property属性快速声明
#define KPropertyString(s)      @property(nonatomic,copy)NSString * s
#define KPropertyNSInteger(s)   @property(nonatomic,assign)NSInteger s
#define KPropertyFloat(s)       @property(nonatomic,assign)float s
#define KPropertyLongLong(s)    @property(nonatomic,assign)long long s
#define KPropertyNSDictionary(s)@property(nonatomic,strong)NSDictionary *s
#define KPropertyNSArray(s)     @property(nonatomic,strong)NSArray *s
#define KPropertyNSMutableArray(s)    @property(nonatomic,strong)NSMutableArray * s

/*****************************强弱引用********************************/
#define WS(weakSelf)            __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf,weakSelf) __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#define kWeakify(var) __weak typeof(var) AHKWeak_##var = var;
#define KStrongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

/***************************图片,颜色,字重*****************************/
/// 随机颜色
#define RandomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

/// 16进制颜色
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UIColorFromRGB_A(rgbValue,alphaValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:alphaValue]

/// RGB颜色
#define RGBA(r, g, b, a)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

/// 苹方 细体
#define DDFont_PF_L(x)     \
([UIFont fontWithName:@"PingFangSC-Light" size:x] ? [UIFont fontWithName:@"PingFangSC-Light" size:x] : [UIFont systemFontOfSize:x])
/// 苹方 常规
#define DDFont_PF_R(x)     \
([UIFont fontWithName:@"PingFangSC-Regular" size:x] ? [UIFont fontWithName:@"PingFangSC-Regular" size:x] : [UIFont systemFontOfSize:x])
/// 苹方 中等
#define DDFont_PF_M(x)     \
([UIFont fontWithName:@"PingFangSC-Medium" size:x] ? [UIFont fontWithName:@"PingFangSC-Medium" size:x] : [UIFont systemFontOfSize:x])
/// 苹方 粗体
#define DDFont_PF_S(x)     \
([UIFont fontWithName:@"PingFangSC-Semibold" size:x] ? [UIFont fontWithName:@"PingFangSC-Semibold" size:x] : [UIFont systemFontOfSize:x])

/***************************通知和本地存储*****************************/
//创建通知
#define KAddNotification(selectorName,key) [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectorName) name:key object:nil];
//发送通知
#define KSendNotification(key,userInf) [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:userInf];
//移除通知
#define KRemoveNotification(key) [[NSNotificationCenter defaultCenter]removeObserver:self name:key object:nil];

//本地化存储
#define KUserDefaults(NSUserDefaults,defu) NSUserDefaults * defu = [NSUserDefaults standardUserDefaults];

/***************************其他*****************************/
//主窗口
#define KApplication [UIApplication sharedApplication].keyWindow
//字符串拼接
#define KStringWithFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]
//GCD代码只执行一次
#define KDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//app名称
#define APPNAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
//app版本
#define APPVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//app build版本
#define APPBUILD [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}

#endif /* Contast_h */
