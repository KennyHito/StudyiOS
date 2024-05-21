//
//  CacheTool.h
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheTool : NSObject
/* 返回多少M*/
+ (NSString *)showCache;

/* 清除缓存*/
+ (void)clearCache;
@end

NS_ASSUME_NONNULL_END
