//
//  TryCatchViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/2/27.
//

#import "TryCatchViewController.h"

@interface TryCatchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconIv;

@end

@implementation TryCatchViewController

- (void)tapGREvent{
    NSString *str = @"测试崩溃,但是第一次可以挽救，点击第二次直接崩溃";
    KLog(@"%@",[str substringFromIndex:111]);  // 程序到这里会崩
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //方法一: CrashHandler类方式,但是第一次可以挽救，点击第二次直接崩溃
    //设置icon
    self.iconIv.image = [UIImage imageNamed:@"lianchu"];
    //设置圆角
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.layer.cornerRadius = 10;
    //可交互性
    self.iconIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGREvent)];
    [self.iconIv addGestureRecognizer:tapGR];
    
    
    //方法二: 通过类别的方式,针对字典或者数组防护
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[@"1",@"2",@"3",@"4"]];
    KLog(@"%@",arr[9999]);
    
    NSMutableDictionary *testDic = [[NSMutableDictionary alloc]init];
    [testDic setObject:@"" forKey:@"name"];
    KLog(@"%@",testDic[@"name"]);
    
    //方法三:@try @catch @finally
    @try {
        NSString *str = @"abc" ;
        KLog(@"%@",[str substringFromIndex:111]);  // 程序到这里会崩
    } @catch (NSException *exception) {
        KLog(@"捕获到的错误：%@", exception);
    } @finally {
        KLog(@"----finally-----");
    }
}

@end
