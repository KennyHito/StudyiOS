//
//  NSString+Common.h
//  StudyiOS
//
//  Created by Apple on 2023/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)
/// 获取手机型号
+(NSString *)getCurrentDeviceModel;
/// 手机号码验证
+(BOOL)isValidateMobile:(NSString *)mobile;
/// 身份证
+(BOOL)isValidateIndCard:(NSString *)mobile;
/// 邮箱验证
+(BOOL)isEmailAddress:(NSString *)nickname;
@end

NS_ASSUME_NONNULL_END
