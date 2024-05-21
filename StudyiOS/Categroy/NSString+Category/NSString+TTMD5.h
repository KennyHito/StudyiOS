//
//  NSString+TTMD5.h
//  iOSTest
//
//  Created by KennyHito on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TTMD5)
/**
 *  @brief 把字符串加密成32位小写md5字符串
 *  @return 加密后的32位小写md5字符串
*/
- (NSString*)md532BitLower;

/**
 *  @brief 把字符串加密成32位大写md5字符串
 *  @return 加密后的32位大写md5字符串
*/
- (NSString*)md532BitUpper;

/**
 *  @brief MD5加密字串
 */
- (NSString *)getMD5Data;

@end

NS_ASSUME_NONNULL_END
