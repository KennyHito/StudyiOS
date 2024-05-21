//
//  TTReadWhiteSafeDic.h
//  iOSTest
//
//  Created by KennyHito on 2022/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTReadWhiteSafeDic : NSObject
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)obj forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
