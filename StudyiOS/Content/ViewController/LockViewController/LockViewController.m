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
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 101;
    self.unfairLock = OS_UNFAIR_LOCK_INIT;
    self.nsLock = [[NSLock alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    for (int i = 0; i < 10; i++) {
    //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //            [self synchronized_test];
    //        });
    //    }
    [self deadlock];
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

#pragma mark -- 死锁deadlock
- (void)deadlock{
    //    死锁三要素：同一队列、同步提交、当前队列正在执行任务。
    
    // 在主线程同步提交任务到主队列（必死锁）
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"永远不会执行");
//    });
    /*
     死锁原因：
     1.主线程正在执行当前代码块。
     2.dispatch_sync要求立即执行任务，但主队列必须等待当前代码块完成。
     3.两者互相等待，导致死锁。
     */
    
    /***********************************华丽的分割线**************************************/
    
    // 在串行队列的任务中同步提交任务到自身
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.serial", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(serialQueue, ^{
//        NSLog(@"任务1开始");
//        // 错误！同步提交任务到当前正在执行的队列
//        dispatch_sync(serialQueue, ^{
//            NSLog(@"任务2（永远不会执行）");
//        });
//        NSLog(@"任务1结束（永远不会执行）");
//    });
    /*
     死锁原因：
     1.任务 1 正在占用serialQueue执行。
     2.dispatch_sync要求立即执行任务 2，但serialQueue被任务 1 占用。
     3.任务 1 等待任务 2 完成，任务 2 等待队列释放，形成循环等待。
     */
    
    /***********************************华丽的分割线**************************************/
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("bj", DISPATCH_QUEUE_SERIAL);
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
