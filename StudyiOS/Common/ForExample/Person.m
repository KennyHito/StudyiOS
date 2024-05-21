//
//  Person.m
//  StudyiOS
//
//  Created by Apple on 2023/10/9.
//

#import "Person.h"
#import <objc/runtime.h>

@interface Person()

@end

@implementation Person

- (void)diuCar{
    KLog(@"车被偷了,人只能跑步来");
}

- (void)run{
    KLog(@"人跑步来的");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    /**
     class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,
     const char * _Nullable types)
     1、Class  cls： 给哪个类添加方法
     2、SEL name：添加什么方法（方法的名称）
     3、IMP imp：一个新方法的实现函数，函数至少有两个参数id self和SEL _cmd
     4、const char * _Nullable types： 方法类型
     v  没有返回值
     @ 对象 id
     :  方法
     5、返回值： 方法添加成功，则返回 YES，否则返回 NO（例如：该类已包含具有该名称的方法实现）。
     */
    //使用runtime 动态添加 eat 方法
    //添加了一个无返回值无参数的方法
    // v@: 表示一个void类型的方法，无返回值
    
    if(sel == NSSelectorFromString(@"eat")){
        class_addMethod(self, sel, (IMP)eat, "v@:");
    }
    
    if (sel == NSSelectorFromString(@"play:")) {
        //添加有返回值有参数的方法
        // v@: 后面的 @ 表示一个对象类型的参数（例中NSNumber类型）
        class_addMethod(self, sel, (IMP)play, "@@:@");
    }
    
    if(sel == NSSelectorFromString(@"more:")){
        Method exchangeM = class_getInstanceMethod([self class], @selector(eatWithPersonName:));
        class_addMethod([self class], sel, class_getMethodImplementation(self, @selector(eatWithPersonName:)),method_getTypeEncoding(exchangeM));
    }
    
    return YES;
}

// eat 方法实现
// self:方法调用者
// _cmd:当前方法编号
// 任何一个方法都能调用self,_cmd,其实任何一个方法都有这两个隐式参数
void eat(id self, SEL _cmd) {
    KLog(@"吃东西");
}

// play: 方法的实现
//返回值是一个 NSString 类型的数据
NSString *play(id self, SEL _cmd, NSString *ball) {
    KLog(@"踢足球 - %@",ball);
    return ball;
}

- (void)eatWithPersonName:(id)name {
    KLog(@"%@",name);
}


@end
