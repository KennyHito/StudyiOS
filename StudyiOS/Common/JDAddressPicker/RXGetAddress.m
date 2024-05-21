//
//  RXGetAddress.m
//  JDAddress
//
//  Created by srx on 16/8/24.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//

#import "RXGetAddress.h"

@implementation RXGetAddress
//获取本地地址
+ (NSArray *)getLocalAreaArray {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    if(path.length <= 0) {
        return nil;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    id JsonObject =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingAllowFragments
                                      error:nil];
    
    NSArray * arr = [[NSArray arrayWithObject:JsonObject] objectAtIndex:0];
    NSMutableArray * _allCitiesArr = [[NSMutableArray alloc] initWithArray:arr];
    
    for(NSInteger i = 0; i < _allCitiesArr.count; i++) {
        NSString * code = _allCitiesArr[i][@"code"];
        if([self screenmaskArea:code]) {
            [_allCitiesArr removeObjectAtIndex:i];
        }
    }
    
    
    return _allCitiesArr;
}

///屏蔽 哪些 省份
+ (BOOL)screenmaskArea:(NSString *)nameCode {
    NSArray * screenMaskArr = @[
                                @"630000", //青海省
                                @"540000", //西藏自治区
                                @"150303" //海南区
                                ];
    
    if([screenMaskArr containsObject:nameCode]) {
        return YES;
    }
    return NO;
}


@end
