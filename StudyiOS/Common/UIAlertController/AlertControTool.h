//
//  AlertControTool.h
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ alertBlock)(NSInteger errorCode);

@interface AlertControTool : NSObject

/* UIAlertController提示框 */
+ (void)alertTitle:(NSString *)title andMessage:(NSString *)message andAction1:(NSString *)cancelActionStr andAction2:(NSString *)rubbishActionStr andBlock:(alertBlock)block;

@end

NS_ASSUME_NONNULL_END
