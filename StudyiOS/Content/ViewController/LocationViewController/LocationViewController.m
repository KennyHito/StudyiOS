//
//  LocationViewController.m
//  Summarize
//
//  Created by KennyHito on 2017/6/27.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "LocationViewController.h"
#import "Location.h"

@interface LocationViewController ()<LocationDelegate>
//设置成属性
@property (nonatomic, strong) Location * location;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.location beginUpdatingLocation];
}

#pragma mark - Location delegate
- (void)locationDidEndUpdatingLocation:(LocationModel *)location {
    //在此对需要的数据进行处理使用
    NSLog(@"国家：%@",location.country);
    NSLog(@"省/直辖市：%@",location.administrativeArea);
    NSLog(@"地级市/直辖市区：%@",location.locality);
    NSLog(@"县/区：%@",location.subLocality);
    NSLog(@"街道：%@",location.thoroughfare);
    NSLog(@"子街道：%@",location.subThoroughfare);
    NSLog(@"经度：%lf",location.longitude);
    NSLog(@"纬度：%lf",location.latitude);
    
    NSString * str = KStringWithFormat(@"%@%@%@%@%@%@\n经度:%f,纬度%f",location.country,location.administrativeArea,location.locality,location.subLocality,location.thoroughfare,location.subThoroughfare,location.longitude,location.latitude);
    [self alertTitle:@"定位" andMessage:str andAction1:@"取消" andAction2:@"确定"];
}

- (void)alertTitle:(NSString *)title andMessage:(NSString *)message andAction1:(NSString *)cancelActionStr andAction2:(NSString *)rubbishActionStr{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionStr style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //简直废话:style:UIAlertActionStyleDestructive
    UIAlertAction *rubbishAction = [UIAlertAction actionWithTitle:rubbishActionStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:rubbishAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//懒加载创建自定制的位置类对象
- (Location *)location {
    if (!_location) {
        _location = [[Location alloc] init];
        _location.delegate = self;
    }
    return _location;
}

@end
