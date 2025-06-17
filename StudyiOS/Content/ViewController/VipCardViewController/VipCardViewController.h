//
//  VipCardViewController.h
//  StudyiOS
//
//  Created by Apple on 2024/8/23.
//

#import "BaseViewController.h"

typedef void(^MyBlock)(NSString * _Nonnull name);

NS_ASSUME_NONNULL_BEGIN

@interface VipCardViewController : BaseViewController

@property (nonatomic,copy) MyBlock block1;

@end

NS_ASSUME_NONNULL_END
