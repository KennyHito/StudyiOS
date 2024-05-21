//
//  NSMutableArray+ObjectAtIndex.m
//  DDDevLib
//
//  Created by wangyu_office_mac on 2017/5/15.
//  Copyright © 2017年. All rights reserved.
//

#import "NSMutableArray+ObjectAtIndex.h"

@implementation NSMutableArray (ObjectAtIndex)
- (BOOL)DD_safeRemoveObject:(id)anObject {
    if (anObject == nil) {
        KLog(@"待移除对象为空，不需要移除");
        return NO;
    }
    
    if (![self containsObject:anObject]) {
        KLog(@"待移除对象不在数组中，无法移除");
        return NO;
    }
    
    [self removeObject:anObject];
    return YES;
}

- (BOOL)DD_safeRemoveObjectAtIndex:(NSUInteger)atIndex {
    if (atIndex >= self.count || atIndex < 0) {
        KLog(@"索引越界，超出数组最大个数，请检查边界条件");
        return NO;
    }
    
    [self removeObjectAtIndex:atIndex];
    
    return YES;
}

- (BOOL)DD_safeInsertObject:(id)anObject atIndex:(NSUInteger)atIndex {
    if (anObject == nil) {
        KLog(@"待插入对象为空，不需要添加");
        return NO;
    }
    if (atIndex > self.count || atIndex < 0) {
        KLog(@"索引越界，超出数组最大个数，请检查边界条件");
        return NO;
    }
    [self insertObject:anObject atIndex:atIndex];
    
    return YES;
}
- (BOOL)DD_safeAddObject:(id)anObject{
    if (anObject == nil) {
        KLog(@"待插入对象为空，不需要添加");
        return NO;
    }
    [self addObject:anObject];
    
    return YES;
}

@end
