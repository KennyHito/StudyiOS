//
//  BaseViewController.h
//  iOSTest
//
//  Created by KennyHito on 2022/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic,strong) NSString *navTitle;//设置子类页面的导航栏标题
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,copy) void(^MyBBLock)(NSString *des);

///进入前台获取的通知,父类未做任何操作,子类需要重写,希望子类实现[super pageActivityStart],以防后期父类统一增加内容
- (void)pageActivityStart;

///获取app当前ViewController,子类可以直接使用
- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
