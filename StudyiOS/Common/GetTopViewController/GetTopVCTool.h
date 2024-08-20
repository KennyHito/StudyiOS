//
//  GetTopVCTool.h
//  StudyiOS
//
//  Created by Apple on 2024/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetTopVCTool : NSObject

+ (instancetype)shareInstance;

#pragma mark -- 下面两个方法用来获取当前最顶层的ViewController
- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
