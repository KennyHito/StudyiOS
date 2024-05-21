//
//  TTStudySingle.m
//  iOSTest
//
//  Created by KennyHito on 2022/8/30.
//
//  学习单例

#import "TTStudySingle.h"

static TTStudySingle *instance = nil;

@implementation TTStudySingle

/*
 如果只有这种方式创建单例,并无法保证项目只有一个对象
 有可能通过new alloc copy mutablecopy的方式创建 这样就无法保证只有一个对象,所以需要重写以下方法
 */
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 方法一: 重写底层的对应方法
//new alloc 这两种方式最终都会走这个方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

//copy最终都会走这个方法
- (nonnull id)copyWithZone:(nullable NSZone *)zone{
    return instance;
}

//mutableCopy最终都会走这个方法
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone{
    return instance;
}

/// 方法二: 在.h文件中查看
@end


