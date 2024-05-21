//
//  HsLcPrivacySetModel.h
//  StudyiOS
//
//  Created by Apple on 2023/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsLcPrivacySetModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *status;
@property (assign, nonatomic) ECAuthorizationStatus statusNum;

@end

NS_ASSUME_NONNULL_END
