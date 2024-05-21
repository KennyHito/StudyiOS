//
//  NSArray+ObjectAtIndex.m
//  CommonFramework
//
//  Created by GaoYong on 15/7/17.
//
//

#import "NSArray+ObjectAtIndex.h"

@implementation NSArray (ObjectAtIndex)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSString *) getJsonDescription{
    NSString *desp = [self.class dataTojsonString:self];
    return desp;
}

+ (NSString *)dataTojsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted  error:&error];
    if (! jsonData) {
        KLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
