//
//  HsWeakScriptMessageDelegate.h
//  StudyiOS
//
//  Created by Apple on 2023/11/7.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

NS_ASSUME_NONNULL_END
