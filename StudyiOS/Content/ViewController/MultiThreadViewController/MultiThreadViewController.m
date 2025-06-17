//
//  MultiThreadViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/19.
//

#import "MultiThreadViewController.h"

@interface MultiThreadViewController ()
@property (weak, nonatomic) IBOutlet UIButton *djsBtn;

@property (nonatomic, strong) TTReadWhiteSafeDic *safeDic;
/// iphone的数量
@property (nonatomic,assign) int iphoneNumber;
/// 互斥用的信号量
@property (nonatomic,strong) dispatch_semaphore_t semaphore;

@end

@implementation MultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bgView setHidden:YES];
    [self initViewStyle];
    //    [self demo1];
    //    [self demo2];
    //    [self demo3];
    //    [self demo4];
    //    [self demo5];
    //    [self demo6];
    //    [self demo7];
    //    [self demo8];
}

- (void)initViewStyle{
    //倒计时开始的样子
    self.djsBtn.layer.masksToBounds = YES;
    self.djsBtn.layer.borderWidth = 1;
    self.djsBtn.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.djsBtn.layer.cornerRadius = 5;
    [self.djsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.djsBtn setTitleColor:UIColorFromRGB(0xEF4034) forState:UIControlStateNormal];
    self.djsBtn.userInteractionEnabled = YES;
}

#pragma mark --- 倒计时
- (IBAction)djsBtnClick:(UIButton *)sender {
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    WS(weakSelf);//⚠️必须使用弱引用,否则会导致循环引用!
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [weakSelf.djsBtn setTitle:@"再次发送" forState:UIControlStateNormal];
                [weakSelf.djsBtn setTitleColor:UIColorFromRGB(0xEF4034) forState:UIControlStateNormal];
                weakSelf.djsBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [weakSelf.djsBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2ds)", seconds] forState:UIControlStateNormal];
                [weakSelf.djsBtn setTitleColor:UIColorFromRGB(0xE6E6E6) forState:UIControlStateNormal];
                weakSelf.djsBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)demo1{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    dispatch_group_t testGroup = dispatch_group_create();
    KLog(@"------1");
    dispatch_group_enter(testGroup);
    dispatch_group_async(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------2");
        dispatch_group_leave(testGroup);
    });
    
    dispatch_group_enter(testGroup);
    dispatch_group_async(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------3");
        dispatch_group_leave(testGroup);
    });
    
    dispatch_group_notify(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------4");
    });
    KLog(@"------5");
}

- (void)demo2{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    KLog(@"%@",[NSThread mainThread]);
    KLog(@"%@",[NSThread currentThread]);
    dispatch_queue_t cQueue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(cQueue, ^{
        KLog(@"%@",[NSThread currentThread]);
    });
}

- (void)demo3{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    NSInvocationOperation *opt1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(opt1Event) object:nil];
    NSInvocationOperation *opt2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(opt2Event) object:nil];
    NSInvocationOperation *opt3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(opt3Event) object:nil];
    
    //📢: 设置依赖关系需要在添加队列之前,否则将不会生效
    [opt1 addDependency:opt2];//opt1依赖opt2
    [opt2 addDependency:opt3];//opt2依赖opt3
    //⚠️当不创建队列的话,默认是在主队列上,其实同步任务,并且需要手动start,故在主线程不能设置依赖关系,也就是说在主线程不能开启同步任务,会导致死锁!
    //    [opt1 start];
    //    [opt2 start];
    //    [opt3 start];
    
    //当添加了队列,会在开启子线程,异步任务,添加到队列中无需手动start,会自动开启
    NSOperationQueue *optQueue = [[NSOperationQueue alloc]init];
    [optQueue addOperation:opt1];//添加队列就会自动创建子线程且无需手动star
    [optQueue addOperation:opt2];
    [optQueue addOperation:opt3];
}

- (void)opt1Event{
    KLog(@"------opt1Event-----");
}

- (void)opt2Event{
    KLog(@"------opt2Event-----");
}

- (void)opt3Event{
    KLog(@"------opt3Event-----");
}

- (void)demo4{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    //代码题：假设ABCDE五个任务，D依赖AB的执行，E依赖BC的执行，怎么设计
    NSBlockOperation *opA = [NSBlockOperation blockOperationWithBlock:^{
        KLog(@"A任务完成");
    }];
    
    NSBlockOperation *opB = [NSBlockOperation blockOperationWithBlock:^{
        KLog(@"B任务完成");
    }];
    
    NSBlockOperation *opC = [NSBlockOperation blockOperationWithBlock:^{
        KLog(@"C任务完成");
    }];
    
    NSBlockOperation *opD = [NSBlockOperation blockOperationWithBlock:^{
        KLog(@"D任务");
    }];
    
    NSBlockOperation *opE = [NSBlockOperation blockOperationWithBlock:^{
        KLog(@"E任务");
    }];
    //D依赖AB的执行
    [opD addDependency:opA];
    [opD addDependency:opB];
    //E依赖BC的执行
    [opE addDependency:opB];
    [opE addDependency:opC];
    
    NSOperationQueue *qu = [[NSOperationQueue alloc] init];
    [qu addOperation:opA];
    [qu addOperation:opB];
    [qu addOperation:opC];
    [qu addOperation:opD];
    [qu addOperation:opE];
}

- (void)demo5{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    KLog(@"currentThread: %@",[NSThread currentThread]);
    KLog(@"mainThread: %@",[NSThread mainThread]);
    [HttpCommonRequest requestByGetWithUrl:Request_Api_1 param:nil success:^(id _Nonnull responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        KLog(@"%@",dic);
        KLog(@"success currentThread: %@",[NSThread currentThread]);
    } failure:^(NSError * _Nonnull error) {
        KLog(@"failure currentThread: %@",[NSThread currentThread]);
    }];
}

- (void)demo6{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    //出现死锁的情况
    //情况1.
    //    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    //    KLog(@"1");
    //    dispatch_async(queue, ^{
    //        KLog(@"2");
    //        dispatch_sync(queue, ^{
    //            KLog(@"3");
    //        });
    //        KLog(@"4");
    //    });
    //    KLog(@"5");
    
    //情况2.
    //    KLog(@"1");
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        KLog(@"2");
    //    });
    //    KLog(@"3");
}

- (void)demo7{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    self.iphoneNumber = 10;
    // 初始化1个信号量
    self.semaphore = dispatch_semaphore_create(1);
    
    /// 通过信号量进行互斥，开启三个窗口(线程)同时卖iphone
    //    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    //    thread1.name = @"窗口1";
    //    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    //    thread2.name = @"窗口2";
    //    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphone) object:nil];
    //    thread3.name = @"窗口3";
    
    /// 通过同步锁进行互斥，开启三个窗口(线程)同时卖iphone
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
    thread1.name = @"窗口1";
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
    thread2.name = @"窗口2";
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellIphoneWithSynchronization) object:nil];
    thread3.name = @"窗口3";
    [thread1 start];
    [thread2 start];
    [thread3 start];
}

/// 通过信号量达到互斥
- (void)sellIphone{
    KLog(@"活动准备开始,倒计时3,2,1");
    while (1) {
        // P操作对信号量进行减一，然后信号量变0，限制其他窗口(线程)进入
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        // 检查还有没iphone可卖
        if (self.iphoneNumber > 0){
            KLog(@"卖出iphone剩下%d台iphone",--self.iphoneNumber);
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

- (void)demo8{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    self.safeDic = [[TTReadWhiteSafeDic alloc]init];
    [self.safeDic setObject:@"xiaoming" forKey:@"name"];
    KLog(@"%@",[self.safeDic objectForKey:@"name"]);
    
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
