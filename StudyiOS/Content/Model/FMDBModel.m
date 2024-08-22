//
//  FMDBModel.m
//  StudyiOS
//
//  Created by Apple on 2024/8/22.
//

#import "FMDBModel.h"

@implementation FMDBModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

@end
