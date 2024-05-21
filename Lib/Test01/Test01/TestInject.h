//
//  TestInject.h
//  Pods
//
//  Created by Apple on 2023/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestInject : NSObject

+ (void)requestApiBlock:(void (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END
