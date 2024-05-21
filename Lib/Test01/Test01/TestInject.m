//
//  TestInject.m
//  Pods
//
//  Created by Apple on 2023/10/25.
//

#import "TestInject.h"
#import <AFNetworking/AFNetworking.h>

@implementation TestInject
+ (void)requestApiBlock:(void (^)(id obj))block{
    NSLog(@"我来测试打印了");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript", @"text/json", nil];
    [manager GET:@"https://api.xygeng.cn/one" parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(error.localizedDescription);
    }];
}
@end
