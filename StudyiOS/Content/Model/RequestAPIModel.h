//
//  RequestAPIModel.h
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestAPIModel : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *updated_at;
@end

NS_ASSUME_NONNULL_END
