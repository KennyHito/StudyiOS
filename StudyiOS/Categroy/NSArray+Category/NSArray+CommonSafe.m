//
//  NSArray+CommonSafe.m
//  DDiPhone
//
//  Created by RentonTheUncoped on 14/11/13.
//  Copyright (c) 2014年. All rights reserved.
//

#import "NSArray+CommonSafe.h"
#import <objc/runtime.h>

@implementation NSArray (CommonSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 对象获取
        // __NSArray0
        dd_swizzleSelector(@"__NSArray0", @"objectAtIndex:", @"Array0_safeObjectAtIndex:");
        dd_swizzleSelector(@"__NSArray0", @"objectAtIndexedSubscript:", @"Array0_safeobjectAtIndexedSubscript:");
        
        // __NSArrayI
        dd_swizzleSelector(@"__NSArrayI", @"objectAtIndex:", @"ArrayI_safeObjectAtIndex:");
        dd_swizzleSelector(@"__NSArrayI", @"objectAtIndexedSubscript:", @"ArrayI_safeobjectAtIndexedSubscript:");
        
        // __NSArrayM
        dd_swizzleSelector(@"__NSArrayM", @"objectAtIndex:", @"ArrayM_safeObjectAtIndex:");
        dd_swizzleSelector(@"__NSArrayM", @"objectAtIndexedSubscript:", @"ArrayM_safeobjectAtIndexedSubscript:");
        
        // __NSSingleObjectArrayI
        dd_swizzleSelector(@"__NSSingleObjectArrayI", @"objectAtIndex:", @"SingleObjectArrayI_safeObjectAtIndex:");
        dd_swizzleSelector(@"__NSSingleObjectArrayI", @"objectAtIndexedSubscript:", @"SingleObjectArrayI_safeobjectAtIndexedSubscript:");
        
        // 对象插入
        dd_swizzleSelector(@"__NSArrayM", @"insertObject:atIndex:", @"ArrayM_safeInsertObject:atIndex:");
        
    });
}

#pragma mark - 对象获取

#pragma mark - __Array0 空数组

- (id)Array0_safeObjectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self Array0_safeObjectAtIndex:index];
}

- (id)Array0_safeobjectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self Array0_safeobjectAtIndexedSubscript:index];
}

#pragma mark - __NSArrayI 不可变数组

- (id)ArrayI_safeObjectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self ArrayI_safeObjectAtIndex:index];
}

- (id)ArrayI_safeobjectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self ArrayI_safeobjectAtIndexedSubscript:index];
}

#pragma mark - __NSArrayM 可变数组

- (id)ArrayM_safeObjectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self ArrayM_safeObjectAtIndex:index];
}

- (id)ArrayM_safeobjectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self ArrayM_safeobjectAtIndexedSubscript:index];
}

#pragma mark - __NSSingleObjectArrayI 单元素数组

- (id)SingleObjectArrayI_safeObjectAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self SingleObjectArrayI_safeObjectAtIndex:index];
}

- (id)SingleObjectArrayI_safeobjectAtIndexedSubscript:(NSUInteger)index {
    if (index < 0 || index >= self.count) {
        KLog(@"数组越界");
        return nil;
    }
    return [self SingleObjectArrayI_safeobjectAtIndexedSubscript:index];
}

#pragma mark - 对象插入

#pragma mark - __NSArrayM 可变数组

- (void)ArrayM_safeInsertObject:anObject atIndex:(NSUInteger)atIndex {
    if (anObject == nil) {
        KLog(@"待插入对象为空，不需要添加");
        return;
    }
    if (atIndex > self.count || atIndex < 0) {
        KLog(@"索引越界，超出数组最大个数，请检查边界条件");
        return;
    }
    [self ArrayM_safeInsertObject:anObject atIndex:atIndex];
}

static inline void dd_swizzleSelector(NSString *the_class, NSString *original, NSString *swizzled) {
    Class class = NSClassFromString(the_class);
    SEL original_selector = NSSelectorFromString(original);
    SEL swizzled_selector = NSSelectorFromString(swizzled);
    
    Method method_original = class_getInstanceMethod(class, original_selector);
    Method method_swizzled = class_getInstanceMethod(class, swizzled_selector);
    if (method_original && method_swizzled) {
        BOOL didAddMethod = class_addMethod(class, original_selector, method_getImplementation(method_swizzled), method_getTypeEncoding(method_swizzled));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzled_selector,
                                method_getImplementation(method_original),
                                method_getTypeEncoding(method_original));
        }else{
            method_exchangeImplementations(method_original, method_swizzled);
        }
    }
}
@end
