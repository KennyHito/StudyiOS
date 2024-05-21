//
//  NSString+Base64.h
//  StudyiOS
//
//  Created by Apple on 2023/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)

/**
 * @brief 返回Base64加密后的字符串
 */
- (NSString *)encodeBase64String;

/**
 * @brief 返回Base64解密后的字符串
 */
- (NSString *)decodeBase64String;

@end

NS_ASSUME_NONNULL_END
