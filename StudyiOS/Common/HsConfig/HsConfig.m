//
//  HsConfig.m
//  StudyiOS
//
//  Created by Apple on 2023/10/26.
//

#import "HsConfig.h"

@implementation HsConfig

+ (id)readUserDefaultWithKey:(NSString *)key{
    if (key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)writeUserDefaultWithKey:(NSString *)key WithValue:(id)value{
    if (key) {
        NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
        if (value) {
            [standardUserDefault setValue:value forKey:key];
        }else {
            [standardUserDefault removeObjectForKey:key];
        }
        [standardUserDefault synchronize];
    }
}
@end
