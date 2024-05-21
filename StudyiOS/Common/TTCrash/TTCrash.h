//
//  TTCrash.h
//  iOSTest
//
//  Created by KennyHito on 2022/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCrash : NSObject

+ (void)installUncaughtSignalExceptionHandler;

@end

NS_ASSUME_NONNULL_END
