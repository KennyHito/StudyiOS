//
//  HitoLocation.m
//  Summarize
//
//  Created by KennyHito on 2017/6/27.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "Location.h"

@interface Location () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager * locationManager;
@property (nonatomic,assign) BOOL isFirstUpdate;

@end

@implementation Location

#pragma mark - public
- (void)beginUpdatingLocation {
    
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    //获取新的位置
    CLLocation * newLocation = locations.lastObject;
    
    //创建自定制位置对象
    LocationModel * location = [[LocationModel alloc] init];
    
    //存储经度
    location.longitude = newLocation.coordinate.longitude;
    
    //存储纬度
    location.latitude = newLocation.coordinate.latitude;
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            CLPlacemark * placemark = placemarks.firstObject;
            //存储位置信息
            location.country = placemark.country;//国家
            location.administrativeArea = placemark.administrativeArea;//省
            location.locality = placemark.locality;//市
            location.subLocality = placemark.subLocality;//县,旗,区
            location.thoroughfare = placemark.thoroughfare;//街道
            location.subThoroughfare = placemark.subThoroughfare;//详细街道
            //设置代理方法
            if ([self.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)]){
                
                [self.delegate locationDidEndUpdatingLocation:location];
            }
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    [manager stopUpdatingHeading];
}


#pragma mark - setter and getter
- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        // 设置定位精确度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        // 取得定位权限，有两个方法，取决于你的定位使用情况
        // 一个是 requestAlwaysAuthorization
        // 一个是 requestWhenInUseAuthorization
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

@end
