//
//  starView.h
//  StarStar
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import <UIKit/UIKit.h>
@class starView;

@protocol starStarDelegate <NSObject>

@optional

- (void)starRatingViewScore:(float)score;

@end


@interface starView : UIView


@property (nonatomic, weak) id <starStarDelegate> delegate;

/**
 *  设置默认星星数量   即设置分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;
@end
