//
//  HttpCommonRequest.h
//  StudyiOS
//
//  Created by Apple on 2025/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpCommonRequest : NSObject

//发起POST请求
+ (void)requestByPostWithUrl:(NSString *_Nonnull)url param:(NSDictionary *_Nullable)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//发起GET请求
+ (void)requestByGetWithUrl:(NSString *_Nonnull)url param:(NSDictionary *_Nullable)param success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
