//
//  HsWeakScriptMessageDelegate.m
//  StudyiOS
//
//  Created by Apple on 2023/11/7.
//

#import "HsWeakScriptMessageDelegate.h"

@implementation HsWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
