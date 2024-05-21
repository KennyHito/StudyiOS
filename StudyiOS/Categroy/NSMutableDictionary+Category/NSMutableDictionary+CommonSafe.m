//
//  NSMutableDictionary+CommonSafe.m
//  StudyiOS
//
//  Created by Apple on 2023/10/16.
//

#import "NSMutableDictionary+CommonSafe.h"

@implementation NSMutableDictionary (CommonSafe)

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

+ (void)load{
    //setObject:forKey:
    dd_swizzleSelector(@"__NSDictionaryM", @"setObject:forKey:", @"em_setObject:forKey:");
    
    //setValue:forKey:
    dd_swizzleSelector(@"__NSDictionaryM", @"setValue:forKey:", @"em_setValue:forKey:");
}

- (void)em_setObject:(id)emObject forKey:(NSString *)key {
    if (emObject && key) {
        [self em_setObject:emObject forKey:key];
    }
}

- (void)em_setValue:(id)value forKey:(NSString *)key{
    if (value && key) {
        [self em_setValue:value forKey:key];
    }
}

@end
