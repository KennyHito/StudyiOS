//
//  Location.h
//  Summarize
//
//  Created by KennyHito on 2017/6/27.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//模型层

@interface LocationModel : NSObject
//国家
@property (nonatomic, copy) NSString * country;
//省 直辖市
@property (nonatomic, copy) NSString * administrativeArea;
//地级市 直辖市区
@property (nonatomic, copy) NSString * locality;
//县 区
@property (nonatomic, copy) NSString * subLocality;
//街道
@property (nonatomic, copy) NSString * thoroughfare;
//子街道
@property (nonatomic, copy) NSString * subThoroughfare;
//经度
@property (nonatomic, assign) CLLocationDegrees longitude;
//纬度
@property (nonatomic, assign) CLLocationDegrees latitude;


@end
