//
//  UIViewController+AddProperty.m
//  iOSTest
//
//  Created by KennyHito on 2022/8/7.
//

#import "UIViewController+AddProperty.h"
#import <objc/runtime.h>

static char kIsPreviewKey;

@implementation UIViewController (AddProperty)

- (NSString *)name{
    id temp = objc_getAssociatedObject(self, &kIsPreviewKey);
    if (!temp) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",temp];
}

- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, &kIsPreviewKey, name, OBJC_ASSOCIATION_RETAIN);
}

@end
