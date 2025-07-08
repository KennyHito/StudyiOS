//
//  VCControllers.m
//  StudyiOS
//
//  Created by Apple on 2025/6/18.
//

#import "VCControllers.h"

@implementation VCControllers

+ (NSArray *)getVCController{
    return @[
        @{Tab_Title:@"各种学习/小功能集合",Tab_Url:@"ExerciseViewController"},
        @{Tab_Title:@"使用定时器注意事项",Tab_Url:@"TimerViewController"},
        @{Tab_Title:@"ReactiveObjC",Tab_Url:@"ReactiveObjCViewController"},
        @{Tab_Title:@"切换App Logo",Tab_Url:@"ChangeLogoViewController"},
        @{Tab_Title:@"测试崩溃一下",Tab_Url:@"TryCatchViewController"},
        @{Tab_Title:@"多线程NSThread、GCD和NSOperation",Tab_Url:@"MultiThreadViewController"},
        @{Tab_Title:@"Runtime",Tab_Url:@"RuntimeViewController"},
        @{Tab_Title:@"截图分享功能",Tab_Url:@"ScreenShotViewController"},
        @{Tab_Title:@"弹球碰撞功能",Tab_Url:@"PinballProViewController"},
        @{Tab_Title:@"设置九宫格密码",Tab_Url:@"SudokuViewController"},
        @{Tab_Title:@"日期选择器",Tab_Url:@"DatePickerVC"},
        @{Tab_Title:@"HTML5交互",Tab_Url:@"HTML5ViewController"},
        @{Tab_Title:@"仿京东地址选择器",Tab_Url:@"AddressViewController"},
        @{Tab_Title:@"AVPlayer播放音频",Tab_Url:@"MusicViewController"},
        @{Tab_Title:@"电商类软件加购动画效果",Tab_Url:@"GuoWuCheViewController"},
        @{Tab_Title:@"判断手机是否越狱",Tab_Url:@"PrisonBreakViewController"},
        @{Tab_Title:@"倒计时功能",Tab_Url:@"CountDownViewcontroller"},
        @{Tab_Title:@"图片保存功能",Tab_Url:@"SavePicViewController"},
        @{Tab_Title:@"网络请求功能",Tab_Url:@"RequestAPIViewController"},
        @{Tab_Title:@"实现本地通知功能",Tab_Url:@"LocalpushViewController"},
        @{Tab_Title:@"原生扫描二维码功能",Tab_Url:@"QRCodeViewController"},
        @{Tab_Title:@"UITouch移动图片位置",Tab_Url:@"UITouchViewController"},
        @{Tab_Title:@"标签选择功能",Tab_Url:@"TagSelectViewController"},
        @{Tab_Title:@"实现瀑布流功能",Tab_Url:@"FallsFlowViewController"},
        @{Tab_Title:@"调用闪光灯功能",Tab_Url:@"FlashlightViewController"},
        @{Tab_Title:@"系统自带定位功能",Tab_Url:@"LocationViewController"},
        @{Tab_Title:@"轮播新闻类功能",Tab_Url:@"YHTScrollViewController"},
        @{Tab_Title:@"实现FMDB库功能",Tab_Url:@"FMDBViewController"},
        @{Tab_Title:@"Masonry库的使用",Tab_Url:@"MasonryViewController"},
        @{Tab_Title:@"类似vip会员样式",Tab_Url:@"VipCardViewController"},
        @{Tab_Title:@"学习各种锁",Tab_Url:@"LockViewController"},
        @{Tab_Title:@"苹果ID登录",Tab_Url:@"APPLEIDLoginController"},
    ];
}

@end
