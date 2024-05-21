//
//  TTMiddleProxy.m
//  iOSTest
//
//  Created by KennyHito on 2022/9/6.
//

#import "TTMiddleProxy.h"

@implementation TTMiddleProxy

+ (instancetype)callObjectTarget:(id)target;{
    TTMiddleProxy *object = [TTMiddleProxy alloc];
    object.target = target;
    return object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

@end
