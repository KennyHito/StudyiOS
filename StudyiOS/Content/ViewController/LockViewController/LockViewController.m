//
//  LockViewController.m
//  StudyiOS
//
//  Created by Apple on 2025/6/16.
//

#import "LockViewController.h"
#import <os/lock.h>

@interface LockViewController ()

@property (nonatomic,assign) int count;
@property (nonatomic,assign) os_unfair_lock unfairLock;
@property (nonatomic,strong) NSLock *nsLock;

@property (nonatomic, strong) TTReadWhiteSafeDic *safeDic;
@property (nonatomic,assign) int iphoneNumber;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initData];
}

- (void)setupUI{
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"通过touchesBegan方式触发";
    lab.font = [UIFont systemFontOfSize:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    [self.bgView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.bgView);
    }];
}

- (void)initData{
    self.count = 101;
    
    self.unfairLock = OS_UNFAIR_LOCK_INIT;
    
    self.nsLock = [[NSLock alloc] init];
    
    self.iphoneNumber = 30;
    self.semaphore = dispatch_semaphore_create(1);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    for (int i = 0; i < 10; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self synchronized_test];
//        });
//    }
//    [self semaphore_test];
    [self NSThread_test];
}

#pragma mark -- os_unfair_lock
- (void)unfairLock_test{
    os_unfair_lock_lock(&_unfairLock);
    self.count--;
    NSLog(@"------> %d",self.count);
    os_unfair_lock_unlock(&_unfairLock);
}

#pragma mark -- NSLock
- (void)nsLock_test{
    [self.nsLock lock];
    self.count--;
    NSLog(@"------> %d",self.count);
    [self.nsLock unlock];
}

#pragma mark -- @synchronized
- (void)synchronized_test{
    @synchronized (self) {
        self.count--;
        NSLog(@"------> %d",self.count);
    }
}

#pragma mark -- 卖手机案例(semaphore || synchronized)
- (void)semaphore_test{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    /// 通过信号量进行互斥，开启三个窗口(线程)同时卖iphone
    NSThread *thread1 = [[NSThread alloc]  initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread1.name = @"窗口1";
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread2.name = @"窗口2";
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    thread3.name = @"窗口3";
    
    /// 通过同步锁进行互斥，开启三个窗口(线程)同时卖iphone
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread1.name = @"窗口1";
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread2.name = @"窗口2";
//    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
//    thread3.name = @"窗口3";
    [thread1 start];
    [thread2 start];
    [thread3 start];
}

/// 通过信号量达到互斥
- (void)sellIphone{
    while (1) {
        // P操作对信号量进行减一，然后信号量变0，限制其他窗口(线程)进入
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        // 检查还有没iphone可卖
        if (self.iphoneNumber > 0){
            KLog(@"%@卖出iphone剩下%d台iphone",[NSThread currentThread].name,--self.iphoneNumber);
        }else{
            KLog(@"iphone没有库存了");
            return;
        }
        // V操作对信号量进行加一，然后信号量为1，其他窗口(线程)就能进入了
        dispatch_semaphore_signal(self.semaphore);
    }
    KLog(@"活动结束了!");
}

/// 通过同步锁进行互斥，通过同步锁会比通过信号量控制的方式多进入该临界代码（线程数量-1）次
- (void)sellIphoneWithSynchronization{
    while (1) {
        @synchronized (self) {
            // 检查还有没iphone可卖
            if (self.iphoneNumber > 0){
                KLog(@"%@卖出iphone剩下%d台iphone",[NSThread currentThread].name,--self.iphoneNumber);
            }else{
                KLog(@"iphone没有库存了");
                return;
            }
        }
    }
}

#pragma mark -- 多读单写
- (void)NSThread_test{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    self.safeDic = [[TTReadWhiteSafeDic alloc]init];
    [self.safeDic setObject:@"xiaoming" forKey:@"name"];
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sell1) object:nil];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sell2) object:nil];
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sell3) object:nil];
    NSThread *thread4 = [[NSThread alloc] initWithTarget:self selector:@selector(sell4) object:nil];
    NSThread *thread5 = [[NSThread alloc] initWithTarget:self selector:@selector(sell4) object:nil];
    [thread1 start];
    [thread2 start];
    [thread3 start];
    [thread4 start];
    [thread5 start];
}

- (void)sell1{
    KLog(@"%s",__func__);
    [self.safeDic setObject:@"xiaoming1" forKey:@"name"];
}

- (void)sell2{
    KLog(@"%s",__func__);
    [self.safeDic setObject:@"xiaoming2" forKey:@"name"];
}

- (void)sell3{
    KLog(@"%s",__func__);
    [self.safeDic setObject:@"xiaoming3" forKey:@"name"];
}

- (void)sell4{
    KLog(@"%@",[self.safeDic objectForKey:@"name"]);
}


@end
