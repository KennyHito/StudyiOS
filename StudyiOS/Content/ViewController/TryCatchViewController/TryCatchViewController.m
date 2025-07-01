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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bgView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self method_1];
    [self method_2];
    [self method_3];
}

#pragma mark 方法一: CrashHandler类方式,但是第一次可以挽救，点击第二次直接崩溃
- (void)method_1{
    //设置icon
    self.iconIv.image = [UIImage imageNamed:@"lianchu"];
    //设置圆角
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.layer.cornerRadius = 10;
    //可交互性
    self.iconIv.userInteractionEnabled = YES;
    [DDUIFunction addViewTapGesture:self.iconIv delegate:self action:@selector(tapGREvent)];
}

- (void)tapGREvent{
    NSString *str = @"abcdefg";
    KLog(@"%@",[str substringFromIndex:999]);  // 程序到这里会崩
}

#pragma mark 方法二: 通过类别的方式,针对字典或者数组防护
- (void)method_2{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[@"1",@"2",@"3",@"4"]];
    KLog(@"%@",arr[999]);
    
    NSMutableDictionary *testDic = [[NSMutableDictionary alloc] init];
    [testDic setObject:@"" forKey:@"name"];
    KLog(@"%@",testDic[@"name"]);
}

#pragma mark 方法三:@try @catch @finally
- (void)method_3{
    @try {
        NSString *str = @"abcdefg" ;
        KLog(@"%@",[str substringFromIndex:999]);  // 程序到这里会崩
    } @catch (NSException *exception) {
        KLog(@"捕获到的错误：%@", exception);
    } @finally {
        KLog(@"----finally-----");
    }
}
@end
