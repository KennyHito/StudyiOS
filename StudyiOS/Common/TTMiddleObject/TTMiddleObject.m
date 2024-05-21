//
//  TTMiddleObject.m
//  iOSTest
//
//  Created by KennyHito on 2022/9/6.
//

#import "TTMiddleObject.h"

@implementation TTMiddleObject

+ (instancetype)callObjectTarget:(id)target;{
    TTMiddleObject *object = [[TTMiddleObject alloc] init];
    object.target = target;
    return object;
}

/// 需要进入消息转发流程
- (id)forwardingTargetForSelector:(SEL)aSelector{
    KLog(@"快速转发");
    return self.target;
}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
//    KLog(@"慢速转发-1");
//    return [self.target methodSignatureForSelector:sel];
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation{
//    KLog(@"慢速转发-2");
//    [invocation invokeWithTarget:self.target];
//}

@end
