//
//  CrashHandler.h
//  RunLoopDemo04
//
//  Created by Harvey on 2016/12/15.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashHandler : NSObject
{
    BOOL ignore;
}

// 单例
+ (instancetype)sharedInstance;

// 设置捕获到崩溃回调自定义的方法
- (void)crash: (void(^)(void))callback;

@end


