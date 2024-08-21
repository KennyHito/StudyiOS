//
//  RequestAPIModel.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "RequestAPIModel.h"

@implementation RequestAPIModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

@end
