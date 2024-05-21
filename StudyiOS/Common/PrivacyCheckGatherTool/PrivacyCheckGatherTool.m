//
//  PrivacyCheckGatherTool.m
//  StudyiOS
//
//  Created by Apple on 2023/10/20.
//

#import "PrivacyCheckGatherTool.h"

@interface PrivacyCheckGatherTool()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,copy) void (^kCLCallBackBlock)(CLAuthorizationStatus status);

@end

@implementation PrivacyCheckGatherTool

#pragma mark --- 共用内容
- (void)callbackOnMainQueue:(dispatch_block_t)block {
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)callbackOnMainQueue:(dispatch_block_t)block {
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)showLocationAlert:(NSString *)title andMessage:(NSString *) message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]]){
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]]){
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}
/***********************************************************************************************************************/

// MARK: - 定位权限判断
+ (ECAuthorizationStatus)locationAuthorizationStatus {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            //用户没有选择是否要使用定位服务（弹框没选择，或者根本没有弹框）
            return ECAuthorizationStatusNotDetermined;
        }
            break;
        case kCLAuthorizationStatusRestricted: {
            //没有获得用户授权使用定位服务, 可能用户没有自己禁止访问授权
            return ECAuthorizationStatusRestricted;
        }
            break;
        case kCLAuthorizationStatusDenied: {
            //用户在设置中关闭定位功能，或者用户明确的在弹框之后选择禁止定位
            return ECAuthorizationStatusDenied;
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:{
            //App始终允许使用定位功能
            return ECAuthorizationStatusAuthorized;
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            //用户在使用期间允许使用定位功能
            return ECAuthorizationStatusAuthorized;
        }
            break;
        default:
            return ECAuthorizationStatusUnable;
            break;
    }
}

- (ECAuthorizationStatus)locationAuthorizationStatus {
    return [[self class] locationAuthorizationStatus];
}

- (void)requestLocationAuthorizationWithIfShowAlertView:(BOOL)ifShowAlert completionHandler:(void(^)(ECAuthorizationStatus status))completionHandler {
    kWeakify(self);
    __block ECAuthorizationStatus lbsStatus = [self locationAuthorizationStatus];
    NSString *title = @"定位权限未开启";
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-位置”中允许%@访问您的位置，用于查找附近营业部等",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    if (lbsStatus == ECAuthorizationStatusNotDetermined) {
        KStrongify(self);
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager requestWhenInUseAuthorization];
        WS(weakSelf);
        [self setKCLCallBackBlock:^(CLAuthorizationStatus status) {
            
            [weakSelf callbackOnMainQueue:^{
                
                switch (status) {
                    case kCLAuthorizationStatusNotDetermined: {
                        lbsStatus = ECAuthorizationStatusNotDetermined;
                    }
                        break;
                    case kCLAuthorizationStatusRestricted: {
                        lbsStatus = ECAuthorizationStatusRestricted;
                    }
                        break;
                    case kCLAuthorizationStatusDenied: {
                        lbsStatus = ECAuthorizationStatusDenied;
                    }
                        break;
                    case kCLAuthorizationStatusAuthorizedAlways: {
                        lbsStatus = ECAuthorizationStatusAuthorized;
                    }
                        break;
                    case kCLAuthorizationStatusAuthorizedWhenInUse: {
                        lbsStatus = ECAuthorizationStatusAuthorized;
                    }
                    default:
                        break;
                }
                if (completionHandler) {
                    completionHandler(lbsStatus);
                }
            }];
        }];
        
    } else {
        if (lbsStatus == ECAuthorizationStatusDenied) {
            [self callbackOnMainQueue:^{
                if (ifShowAlert) {
                    [PrivacyCheckGatherTool showLocationAlert:title andMessage:message];
                }
                if (completionHandler) {
                    completionHandler(lbsStatus);
                }
            }];
        } else {
            [self callbackOnMainQueue:^{
                if (completionHandler) {
                    completionHandler(lbsStatus);
                }
            }];
        }
        
    }
}

- (void)requestLocationAuthorizationWithCompletionHandler:(void(^)(ECAuthorizationStatus status))completionHandler {
    [self requestLocationAuthorizationWithIfShowAlertView:YES completionHandler:completionHandler];
}

// CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.kCLCallBackBlock) {
        self.kCLCallBackBlock(status);
    }
}

/***********************************************************************************************************************/
// MARK: - 通知权限判断
+ (ECAuthorizationStatus)pushAuthorizationStatus {
    UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        return  ECAuthorizationStatusDenied;
    } else {
        return  ECAuthorizationStatusAuthorized;
    }
}

+ (void)requestPushAuthorizationWithCompletionHandler:(void(^)(void))completionHandler {
    ECAuthorizationStatus status = [self pushAuthorizationStatus];
    NSString *title = @"通知权限未开启";
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-通知”中允许%@,用于接收APP通知推送消息等",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    if (status == ECAuthorizationStatusDenied) {
        [self callbackOnMainQueue:^{
            [PrivacyCheckGatherTool showLocationAlert:title andMessage:message];
            if (completionHandler) {
                completionHandler();
            }
        }];
    }
}

/***********************************************************************************************************************/
// MARK: - 相机权限判断
+ (ECAuthorizationStatus)cameraAuthorizationStatus {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            return ECAuthorizationStatusNotDetermined;
        } else if (status == AVAuthorizationStatusRestricted){
            return ECAuthorizationStatusRestricted;
        } else if (status == AVAuthorizationStatusDenied) {
            return ECAuthorizationStatusDenied;
        } else {
            return ECAuthorizationStatusAuthorized;
        }
    } else {
        return ECAuthorizationStatusUnable;
    }
}

+ (void)requestCameraAuthorizationWithCompletionHandler:(void(^)(BOOL granted))completionHandler {
    return [self requestCameraAuthorizationWithIfShowAlertView:YES completionHandler:completionHandler];
}

+ (void)requestCameraAuthorizationWithIfShowAlertView:(BOOL)ifShowAlert completionHandler:(void(^)(BOOL granted))completionHandler {
    ECAuthorizationStatus status = [self cameraAuthorizationStatus];
    NSString *title = @"相机权限未开启";
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”中允许%@访问您的相机，用于拍照、扫描、录制视频等",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    if (status == ECAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            [self callbackOnMainQueue:^{
                if (completionHandler) {
                    completionHandler(granted);
                }
            }];
        }];
    } else {
        [self callbackOnMainQueue:^{
            if (completionHandler) {
                completionHandler(status == ECAuthorizationStatusAuthorized);
            }
            if (ifShowAlert && status != ECAuthorizationStatusAuthorized) {
                [PrivacyCheckGatherTool showLocationAlert:title andMessage:message];
            }
        }];
    }
}

- (void)requestCameraAuthorizationWithCompletionHandler:(void(^)(BOOL granted))completionHandler {
    [[self class] requestCameraAuthorizationWithCompletionHandler:completionHandler];
}

/***********************************************************************************************************************/
// MARK: - 相册权限判断
+ (ECAuthorizationStatus)photosAuthorizationStatus {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            return ECAuthorizationStatusNotDetermined;
        } else if (status == PHAuthorizationStatusRestricted) {
            return ECAuthorizationStatusRestricted;
        } else if (status == PHAuthorizationStatusDenied) {
            return ECAuthorizationStatusDenied;
        } else {
            return ECAuthorizationStatusAuthorized;
        }
    } else {
        return ECAuthorizationStatusUnable;
    }
}

+ (void)requestPhotosAuthorizationWithCompletionHandler:(void(^)(BOOL granted))completionHandler {
    [self requestPhotosAuthorizationWithIfShowAlertView:YES completionHandler:completionHandler];
}

+ (void)requestPhotosAuthorizationWithIfShowAlertView:(BOOL)ifShowAlert completionHandler:(void(^)(BOOL granted))completionHandler {
    ECAuthorizationStatus photosAuthorizationStatus = [self photosAuthorizationStatus];
    NSString *title = @"相册权限未开启";
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”中允许%@访问您的照片，用于图片、照片上传等",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    if (photosAuthorizationStatus == ECAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self callbackOnMainQueue:^{
                if (ifShowAlert && !status) {
                    [PrivacyCheckGatherTool showLocationAlert:title andMessage:message];
                }
                if (completionHandler) {
                    completionHandler(status == PHAuthorizationStatusAuthorized);
                }
            }];
        }];
    } else {
        [self callbackOnMainQueue:^{
            if (completionHandler) {
                completionHandler(photosAuthorizationStatus == ECAuthorizationStatusAuthorized);
            }
            if (ifShowAlert && photosAuthorizationStatus != ECAuthorizationStatusAuthorized) {
                [PrivacyCheckGatherTool showLocationAlert:title andMessage:message];
            }
        }];
    }
}

/***********************************************************************************************************************/
// MARK: - 网络权限判断 0无网络,1蜂窝,2WiFi
+ (void)requestNetworkAuthorizationWithCompletionHandler:(void(^)(NSInteger type))completionHandler {
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSInteger types = 0;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://网络错误
                types = 0;
                break;
            case AFNetworkReachabilityStatusNotReachable://没有连接网络
                types = 0;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN://手机自带网络,蜂窝
                types = 1;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://wifi
                types = 2;
                break;
            default:
                break;
        }
        if(completionHandler){
            completionHandler(types);
        }
    }];
}

@end
