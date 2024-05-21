//
//  NSDictionary+JSON.m
//  StudyiOS
//
//  Created by Apple on 2023/10/26.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString*)jsonString{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
