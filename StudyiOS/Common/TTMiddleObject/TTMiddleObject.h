//
//  TTMiddleObject.h
//  iOSTest
//
//  Created by KennyHito on 2022/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMiddleObject : NSObject

@property (nonatomic,weak) id target;

+ (instancetype)callObjectTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
