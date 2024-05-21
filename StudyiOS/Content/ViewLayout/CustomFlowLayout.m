//
//  CustomFlowLayout.m
//  StudyiOS
//
//  Created by Apple on 2023/10/30.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout

// 显示范围发生改变的时候，是否需要重新刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

// cell item Left Aligned(左对齐)
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    CGFloat left = self.left ?  self.left : self.sectionInset.left;
    CGFloat Y = 0;
    CGFloat X = left;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (attrs.indexPath.row == 0) {
            // item是一行一行的显示，第一个元素肯定是一行的第一个元素
            Y = attrs.frame.origin.y;
            X = left;
        }else {
            if (Y != attrs.frame.origin.y) { // 换行
                X = left;  // 新的行第一个的X值
                Y = attrs.frame.origin.y;    // 保存新行的Y值
            }
        }
        CGRect frame = attrs.frame;
        frame.origin = CGPointMake(X, Y);
        attrs.frame = frame;
        X = CGRectGetMaxX(frame) + self.minimumInteritemSpacing;
    }
    return array;
}

@end
