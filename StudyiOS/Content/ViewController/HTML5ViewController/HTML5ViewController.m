//
//  HTML5ViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/7.
//

#import "HTML5ViewController.h"
#import <WebKit/WebKit.h>
#import "HsWeakScriptMessageDelegate.h"
@interface HTML5ViewController ()
<WKScriptMessageHandler,
WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation HTML5ViewController

- (void)dealloc{
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"FirstJsObect"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    //1、该对象提供了通过js向web view发送消息的途径
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //添加在js中操作的对象名称，通过该对象来向web view发送消息
    [userContentController addScriptMessageHandler:[[HsWeakScriptMessageDelegate alloc]initWithDelegate:self] name:@"FirstJsObect"];
    [userContentController addUserScript:wkUScript];
    
    //2、
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = userContentController;
    
    //3、通过初试化方法，生成webview对象并完成配置
    self.wkWebView = [[WKWebView alloc]initWithFrame:self.bgView.bounds configuration:config];
    self.wkWebView.navigationDelegate = self;
    [self.bgView addSubview:self.wkWebView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [DDToast showToast:KStringWithFormat(@"%@,%@",message.body[@"name"],message.body[@"age"])];
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁用选中效果
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
}

@end
