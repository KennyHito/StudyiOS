//
//  NSDictionary+JSON.h
//  StudyiOS
//
//  Created by Apple on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JSON)
/// 字典转json字符串
- (NSString*)jsonString;

@end

NS_ASSUME_NONNULL_END
