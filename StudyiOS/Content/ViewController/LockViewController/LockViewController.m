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
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}
@end
