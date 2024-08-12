//
//  YYKeyChainData.h
//  TruckDriver
//
//  Created by Apple on 2019/1/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYKeyChainData : NSObject

+ (NSString *)getUUIDByKeyChain;               // 获取UUID
+ (void)save:(NSString*)service data:(id)data; // 保存
+ (id)load:(NSString*)service;                 // 获取
+ (void)deleteKeyData:(NSString*)service;      // 删除
@end

NS_ASSUME_NONNULL_END
