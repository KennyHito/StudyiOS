//
//  TTReadWhiteSafeDic.m
//  iOSTest
//
//  Created by KennyHito on 2022/9/16.
//

#import "TTReadWhiteSafeDic.h"

@interface TTReadWhiteSafeDic()
{
    // 定义一个并发队列
    dispatch_queue_t concurrent_queue;
}
// 用户数据中心, 可能多个线程需要数据访问
@property (nonatomic,strong)NSMutableDictionary *userCenterDic;

@end

@implementation TTReadWhiteSafeDic

- (id)init {
    self = [super init];
    if (self) {
        // 通过宏定义 DISPATCH_QUEUE_CONCURRENT 创建一个并发队列
        concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据容器
        self.userCenterDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    __block id obj;
    // 异步读取指定数据
    dispatch_sync(concurrent_queue, ^{// dispatch_sync 设置为同步读取
        obj = [self.userCenterDic objectForKey:key];
    });
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key {
    // 异步栅栏调用设置数据
    key = [key copy];
    dispatch_barrier_async(concurrent_queue, ^{
        [self.userCenterDic setObject:obj forKey:key];
    });
}


@end
