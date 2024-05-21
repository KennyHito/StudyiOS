//
//  PrivacyCheckGatherTool.h
//  StudyiOS
//
//  Created by Apple on 2023/10/20.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/// 授权状态
typedef NS_ENUM(NSInteger, ECAuthorizationStatus) {
    ECAuthorizationStatusUnable = -1,           //不支持或不可用
    ECAuthorizationStatusNotDetermined = 0,     //用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    ECAuthorizationStatusRestricted,            //应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    ECAuthorizationStatusDenied,                //用户拒绝
    ECAuthorizationStatusAuthorized             //已授权
};

@interface PrivacyCheckGatherTool : NSObject

// MARK: - 定位权限判断
+ (ECAuthorizationStatus)locationAuthorizationStatus;

- (void)requestLocationAuthorizationWithCompletionHandler:(void(^)(ECAuthorizationStatus status))completionHandler;

/***********************************************************************************************************************/
// MARK: - 通知权限判断
+ (ECAuthorizationStatus)pushAuthorizationStatus;

+ (void)requestPushAuthorizationWithCompletionHandler:(void(^)(void))completionHandler;

/***********************************************************************************************************************/
// MARK: - 相机权限判断
+ (ECAuthorizationStatus)cameraAuthorizationStatus;

+ (void)requestCameraAuthorizationWithCompletionHandler:(void(^)(BOOL granted))completionHandler;

/***********************************************************************************************************************/
// MARK: - 相册权限判断
+ (ECAuthorizationStatus)photosAuthorizationStatus;

+ (void)requestPhotosAuthorizationWithCompletionHandler:(void(^)(BOOL granted))completionHandler;

/***********************************************************************************************************************/
// MARK: - 网络权限判断 0无网络,1蜂窝,2WiFi
+ (void)requestNetworkAuthorizationWithCompletionHandler:(void(^)(NSInteger type))completionHandler;
@end

NS_ASSUME_NONNULL_END
