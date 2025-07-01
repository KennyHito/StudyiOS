//
//  MultiThreadViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/19.
//

#import "MultiThreadViewController.h"

@interface MultiThreadViewController ()
@property (weak, nonatomic) IBOutlet UIButton *djsBtn;
@end

@implementation MultiThreadViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bgView setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self demo4];
//    [self demo5];
//    [self demo6];
//    [self demo7];
}

#pragma mark -- GCD实现倒计时按钮
- (void)demo{
    self.djsBtn.layer.masksToBounds = YES;
    self.djsBtn.layer.borderWidth = 1;
    self.djsBtn.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.djsBtn.layer.cornerRadius = 5;
    [self.djsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.djsBtn setTitleColor:UIColorFromRGB(0xEF4034) forState:UIControlStateNormal];
    self.djsBtn.userInteractionEnabled = YES;
}

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

#pragma mark -- dispatch_group_t
- (void)demo1{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    dispatch_group_t testGroup = dispatch_group_create();
    KLog(@"------1");
    dispatch_group_enter(testGroup);
    dispatch_group_async(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------2");
        sleep(2);
        dispatch_group_leave(testGroup);
    });
    
    dispatch_group_enter(testGroup);
    dispatch_group_async(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------3");
        sleep(2);
        dispatch_group_leave(testGroup);
    });
    
    dispatch_group_notify(testGroup, dispatch_get_main_queue(), ^{
        KLog(@"------4");
    });
    KLog(@"------5");
}

#pragma mark -- NSThread currentThread
- (void)demo2{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    KLog(@"%@",[NSThread mainThread]);
    KLog(@"%@",[NSThread currentThread]);
    dispatch_queue_t cQueue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(cQueue, ^{
        KLog(@"%@",[NSThread currentThread]);
    });
}

#pragma mark -- NSInvocationOperation
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

#pragma mark -- NSBlockOperation
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

#pragma mark -- 接口请求
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

#pragma mark -- 死锁
- (void)demo6{
    KLog(@"👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻👇🏻");
    //⚠️死锁三要素：同一队列、同步提交、当前队列正在执行任务。
    
    // 在主线程同步提交任务到主队列（必死锁）
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"永远不会执行");
    });
    /*
     死锁原因：
     1.主线程正在执行当前代码块。
     2.dispatch_sync要求立即执行任务，但主队列必须等待当前代码块完成。
     3.两者互相等待，导致死锁。
     */
    
    /***********************************华丽的分割线**************************************/
    
    // 在串行队列的任务中同步提交任务到自身
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"任务1开始");
        // 错误！同步提交任务到当前正在执行的队列
        dispatch_sync(serialQueue, ^{
            NSLog(@"任务2（永远不会执行）");
        });
        NSLog(@"任务1结束（永远不会执行）");
    });
    /*
     死锁原因：
     1.任务 1 正在占用serialQueue执行。
     2.dispatch_sync要求立即执行任务 2，但serialQueue被任务 1 占用。
     3.任务 1 等待任务 2 完成，任务 2 等待队列释放，形成循环等待。
     */
}

#pragma mark -- 异步async || 同步sync
- (void)demo7{
    //⚠️只有在并发队列开启异步线程,才会并发执行任务
    
    dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
    // 当前线程（假设为主线程）
    NSLog(@"主线程执行中，线程ID: %@", [NSThread currentThread]);
    // 同步提交任务1
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务1执行，线程ID: %@", [NSThread currentThread]);
        sleep(1); // 模拟耗时操作
    });
    // 同步提交任务2
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务2执行，线程ID: %@", [NSThread currentThread]);
        sleep(1);
    });
    // 同步提交任务3
    dispatch_async(concurrentQueue, ^{
        NSLog(@"任务3执行，线程ID: %@", [NSThread currentThread]);
        sleep(1);
    });
    NSLog(@"主线程继续执行");
}
@end
