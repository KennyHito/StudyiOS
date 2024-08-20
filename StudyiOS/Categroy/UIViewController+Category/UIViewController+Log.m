//
//  ViewController+Log.m
//  DDiPhone
//
//  Created by wangshun on 14/11/25.
//

#import "UIViewController+Log.h"
#import <objc/runtime.h>

@implementation UIViewController (UserOperateLog)

+ (void)load{
    [self swizz_exchangeInstanceMethod:[self class] originalSelector:@selector(viewDidLoad) newSEL:@selector(viewDidLoadLog)];
    [self swizz_exchangeInstanceMethod:[self class] originalSelector:@selector(viewWillAppear:) newSEL:@selector(viewWillAppearLog:)];
    [self swizz_exchangeInstanceMethod:[self class] originalSelector:@selector(viewWillDisappear:) newSEL:@selector(viewWillDisappearLog:)];
}

+(void) swizz_exchangeInstanceMethod:(Class) class_ originalSelector:(SEL) originalSelector newSEL:(SEL) alternativeSelector{
    Method originalMethod = class_getInstanceMethod(class_, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(class_, alternativeSelector);
    
    if(class_addMethod(class_, originalSelector, method_getImplementation(alternativeMethod), method_getTypeEncoding(alternativeMethod))) {
        class_replaceMethod(class_, alternativeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, alternativeMethod);
    }
}

- (void)viewDidLoadLog{
    KLog(@"🚁进入了: %@", NSStringFromClass([self class]));
    [self viewDidLoadLog];
}

- (void)viewWillAppearLog:(BOOL)animated{
    KLog(@"🛫🛬再次进入了: %@", NSStringFromClass([self class]));
    [self viewWillAppearLog:animated];
}

- (void)viewWillDisappearLog:(BOOL)animated{
    KLog(@"🥊离开了: %@", NSStringFromClass([self class]));
    [self viewWillDisappearLog:animated];
}

@end
