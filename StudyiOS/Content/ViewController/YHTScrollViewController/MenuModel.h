//
//  MenuModel.h
//  iOSReview
//
//  Created by Apple on 2017/7/20.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject
#define PROPERTY(key) @property (nonatomic,strong) NSString * key

PROPERTY(Name);//名称
PROPERTY(PriceStr);//价位
PROPERTY(priceName);//价位区间
PROPERTY(ShowTime);//表演时间
PROPERTY(VenName);//表演地点
PROPERTY(cityname);//表演城市

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
