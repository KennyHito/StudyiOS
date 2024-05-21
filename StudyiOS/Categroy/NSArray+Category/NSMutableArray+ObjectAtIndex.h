//
//  NSMutableArray+ObjectAtIndex.h
//  DDDevLib
//
//  Created by wangyu_office_mac on 2017/5/15.
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ObjectAtIndex)
/**
 *
 *  将对象移除
 *
 *  @param atIndex  位置
 *  @return YES 表示成功，NO表示失败
 */
- (BOOL)DD_safeRemoveObjectAtIndex:(NSUInteger)atIndex;

/**
 *
 *  将对象移除
 *
 *  @param anObject  待移除对象
 *
 *  @return YES，表示成功，NO表示失败
 */
- (BOOL)DD_safeRemoveObject:(id)anObject;

/**
 *
 * @param anObject 待插入对象
 * @param atIndex  插入位置
 *
 * @return YES表示成功，NO表示插入失败
 */
- (BOOL)DD_safeInsertObject:(id)anObject atIndex:(NSUInteger)atIndex;

/**
 防止崩溃
 
 @param anObject 非nil
 @return 插入了返回YES
 */
- (BOOL)DD_safeAddObject:(id)anObject;
@end
