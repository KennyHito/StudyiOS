//
//  Car.m
//  StudyiOS
//
//  Created by Apple on 2023/10/9.
//

#import "Car.h"

@interface Car()

@property (weak) Person *per;

@end


@implementation Car

+ (instancetype)callObjectTarget:(id)per{
    Car *subCar = [Car alloc];
    subCar.per = per;
    return subCar;
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    return self.per;
}

//- (void)diuCar{
//    KLog(@"要你管~");
//}


@end
