//
//  APPLEIDLoginController.m
//  StudyiOS
//
//  Created by Apple on 2025/6/24.
//

#import "APPLEIDLoginController.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface APPLEIDLoginController ()
<
ASAuthorizationControllerDelegate,
ASAuthorizationControllerPresentationContextProviding
>

@property (strong,nonatomic) ASAuthorizationAppleIDButton *authorizationButton API_AVAILABLE(ios(13.0));
@end

@implementation APPLEIDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)configUI{
    if (@available(iOS 13.0, *)) {
        self.authorizationButton = [[ASAuthorizationAppleIDButton alloc]init];
        [self.authorizationButton addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
        self.authorizationButton.center = self.view.center;
        [self.view addSubview:self.authorizationButton];
    } else {
        // Fallback on earlier versions
    }
}

-(void)click API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    auth.delegate = self;
    auth.presentationContextProvider = self;
    [auth performRequests];
}

///代理主要用于展示在哪里
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.view.window;
}


-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
        if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
            ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
            ///将返回得到的user 存储起来
            NSString *identifier = appleIDCredential.user;
            NSPersonNameComponents *fullName = appleIDCredential.fullName;
            NSString *email = appleIDCredential.email;
            NSString *authorizationCode = [[NSString alloc] initWithData:appleIDCredential.authorizationCode encoding:NSUTF8StringEncoding];
            NSString *token = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
            
            KLog(@"identifier: %@\n fullName: %@\n email: %@\n authorizationCode: %@\n token:%@",
                 identifier,fullName,email,authorizationCode,token);
            
        }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
            
            //// Sign in using an existing iCloud Keychain credential.
            ASPasswordCredential *pass = (ASPasswordCredential *)authorization.credential;
            NSString *username = pass.user;
            NSString *passw = pass.password;
            KLog(@"%@%@",username,passw);
        }
    
}

///回调失败
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSLog(@"%@",error);
}

@end
