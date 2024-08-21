//
//  HitoLocation.h
//  Summarize
//
//  Created by KennyHito on 2017/6/27.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocationModel.h"
//协议
@protocol LocationDelegate <NSObject>

- (void)locationDidEndUpdatingLocation:(LocationModel *)location;

@end

@interface Location : NSObject

@property (nonatomic, weak) id<LocationDelegate> delegate;

- (void)beginUpdatingLocation;

@end
