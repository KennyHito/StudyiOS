//
//  TTStudySingle.h
//  iOSTest
//
//  Created by KennyHito on 2022/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTStudySingle : NSObject

+ (instancetype)shareInstance;

/*方法二:
 NS_UNAVAILABLE标记方法不可用。Xcode不会自动补全，代码中如果调用此方法，会编译报错。但是runtime依然可以调用到此方法。
 */
//+ (instancetype)alloc NS_UNAVAILABLE;
//- (instancetype)init NS_UNAVAILABLE;
//+ (instancetype)new NS_UNAVAILABLE;
//- (id)copy NS_UNAVAILABLE;
//- (id)mutableCopy NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
