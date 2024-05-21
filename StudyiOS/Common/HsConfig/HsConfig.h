//
//  HsConfig.h
//  StudyiOS
//
//  Created by Apple on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsConfig : NSObject

/**
 * @desc  轻度级配置项读写函数
 * @param key 配置项的key
 * @note  操作文件类是[NSUserDefaults standardUserDefaults]。
 */
+ (id)readUserDefaultWithKey:(NSString *)key;
+ (void)writeUserDefaultWithKey:(NSString *)key WithValue:(id)value;

@end

NS_ASSUME_NONNULL_END
