//
//  NSString+Base64.m
//  StudyiOS
//
//  Created by Apple on 2023/10/24.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

- (NSString *)encodeBase64String{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)decodeBase64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
