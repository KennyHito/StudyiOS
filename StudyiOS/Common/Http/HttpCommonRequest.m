//
//  HttpCommonRequest.m
//  StudyiOS
//
//  Created by Apple on 2025/6/17.
//

#import "HttpCommonRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation HttpCommonRequest

//发起POST请求
+ (void)requestByPostWithUrl:(NSString *_Nonnull)url param:(NSDictionary *_Nullable)param success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure{
    NSDictionary * paramDic;
    if (param == nil) {
        paramDic = @{};
    } else {
        paramDic = [param copy];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript", @"text/json", nil];
    [manager GET:url parameters:paramDic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//发起GET请求
+ (void)requestByGetWithUrl:(NSString * _Nonnull)url param:(NSDictionary *_Nullable)param success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure{
    NSDictionary * paramDic;
    if (param == nil) {
        paramDic = @{};
    } else {
        paramDic = [param copy];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript", @"text/json", nil];
    [manager POST:url parameters:paramDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
